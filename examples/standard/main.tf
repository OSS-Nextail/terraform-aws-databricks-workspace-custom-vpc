locals {
  resource_prefix = "databricks-example"

  databricks_root_bucket_name = "databricks-example-root-bucket"

  default_tags = {
    "Project" = "databricks-example"
    "Team"    = "infrastructure"
  }

  databricks_subnets = [
    {
      main_subnet_cidr_block = "10.100.128.0/21",
      nat_subnet_cidr_block  = "10.100.152.0/24",
      availability_zone      = data.aws_availability_zones.available.names[0]
    },
    {
      main_subnet_cidr_block = "10.100.136.0/21",
      nat_subnet_cidr_block  = "10.100.153.0/24",
      availability_zone      = data.aws_availability_zones.available.names[1]
    }
  ]

  security_group_egress_ports = [80, 8080]

}

data "aws_region" "current" {
}

data "aws_availability_zones" "available" {
}

provider "databricks" {
  alias    = "mws"
  host     = "https://accounts.cloud.databricks.com"
  username = var.databricks_account_username
  password = var.databricks_account_password
}

module "databricks_workspace_example" {
  source = "nextail/aws/databricks-workspace-custom-vpc"
  providers = {
    databricks = databricks.mws
  }

  resource_prefix             = local.resource_prefix
  root_bucket_name            = local.databricks_root_bucket_name
  databricks_account_id       = var.databricks_account_id
  aws_region                  = data.aws_region.current.name
  default_tags                = local.default_tags
  vpc_id                      = var.vpc_id
  subnets                     = local.databricks_subnets
  security_group_egress_ports = local.security_group_egress_ports
}

provider "databricks" {
  alias = "workspace"
  host  = module.databricks_workspace_example.databricks_host
  token = module.databricks_workspace_example.databricks_token
}

# Databricks workspace resources workspace created here with provider databricks.workspace
