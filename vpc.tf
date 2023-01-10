locals {
  default_sg_egress_ports = [443, 3306, 6666]
  sg_egress_ports         = toset(concat(local.default_sg_egress_ports, var.security_group_egress_ports))
  sg_ingress_protocol     = ["tcp", "udp"]
  sg_egress_protocol      = ["tcp", "udp"]
  # [{subnet1}, {subnet2}, ...] -> {0: {subnet1}, 1: {subnet2}, ...}
  subnets_map = zipmap(range(length(var.subnets)), var.subnets)

  # vpc endpoints
  all_endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = [for k, v in aws_route_table.databricks_main_route_tables : v.id]
      tags = merge(var.default_tags, {
        Name = "${var.resource_prefix}-${var.workspace}-s3-vpc-endpoint"
      })
    }

    kinesis-streams = {
      service             = "kinesis-streams"
      private_dns_enabled = true
      subnet_ids          = [for k, v in aws_subnet.databricks_subnets : v.id]
      tags = merge(var.default_tags, {
        Name = "${var.resource_prefix}-${var.workspace}-kinesis-vpc-endpoint"
      })
    }

    sts = {
      service             = "sts"
      private_dns_enabled = true
      subnet_ids          = [for k, v in aws_subnet.databricks_subnets : v.id]
      tags = merge(var.default_tags, {
        Name = "${var.resource_prefix}-${var.workspace}-sts-vpc-endpoint"
      })
    }
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "this" {
  name        = "${var.resource_prefix}-${var.workspace}"
  description = "Security group for Databricks"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.sg_ingress_protocol
    content {
      from_port = 0
      to_port   = 65535
      protocol  = ingress.value
      self      = true
    }
  }

  dynamic "egress" {
    for_each = local.sg_egress_protocol
    content {
      from_port       = 0
      to_port         = 65535
      protocol        = egress.value
      self            = true
      security_groups = var.security_groups_to_allow_egress_to
    }
  }

  dynamic "egress" {
    for_each = local.sg_egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = var.default_tags
}

resource "aws_subnet" "databricks_subnets" {
  for_each = local.subnets_map

  vpc_id            = var.vpc_id
  cidr_block        = each.value.main_subnet_cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-main-subnet-${each.value.availability_zone}"
  })
}

resource "aws_subnet" "databricks_nat_subnets" {
  for_each = local.subnets_map

  vpc_id            = var.vpc_id
  cidr_block        = each.value.nat_subnet_cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-NAT-gateway-subnet-${each.value.availability_zone}"
  })
}

resource "aws_eip" "databricks_nat_gateways_eips" {
  for_each = local.subnets_map

  vpc = true

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-NAT-gateway-EIP-${each.value.availability_zone}"
  })
}

resource "aws_nat_gateway" "databricks_nat_gateways" {
  for_each = local.subnets_map

  subnet_id         = aws_subnet.databricks_nat_subnets[each.key].id
  allocation_id     = aws_eip.databricks_nat_gateways_eips[each.key].id
  connectivity_type = "public"

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-NAT-gateway-${each.value.availability_zone}"
  })
}

resource "aws_route_table" "databricks_main_route_tables" {
  for_each = local.subnets_map

  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.databricks_nat_gateways[each.key].id
  }

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-main-route-table-${each.value.availability_zone}"
  })
}

resource "aws_route_table" "databricks_nat_route_tables" {
  for_each = local.subnets_map

  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = merge(var.default_tags, {
    Name = "${var.resource_prefix}-${var.workspace}-nat-route-table-${each.value.availability_zone}"
  })
}

resource "aws_route_table_association" "databricks_main_route_tables_associations" {
  for_each = local.subnets_map

  subnet_id      = aws_subnet.databricks_subnets[each.key].id
  route_table_id = aws_route_table.databricks_main_route_tables[each.key].id
}

resource "aws_route_table_association" "databricks_nat_route_tables_associations" {
  for_each = local.subnets_map

  subnet_id      = aws_subnet.databricks_nat_subnets[each.key].id
  route_table_id = aws_route_table.databricks_nat_route_tables[each.key].id
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.2.0"

  vpc_id             = var.vpc_id
  security_group_ids = [aws_security_group.this.id]

  endpoints = { for k, v in local.all_endpoints : k => v if try(var.vpc_endpoints[k], false) }

  tags = var.default_tags
}
