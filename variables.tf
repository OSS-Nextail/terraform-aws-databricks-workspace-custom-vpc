variable "resource_prefix" {
  description = "Prefix to apply in the names of shared AWS resources to be created for the workspace"
  type        = string

  validation {
    condition     = trimspace(var.resource_prefix) != ""
    error_message = "The resource_prefix value must be a non-empty string."
  }
}

variable "workspace_environment_names" {
  description = <<EOF
(optional) Databricks workspaces environment(s) name(s), to use with the deployment and workspace names. Will deploy as many workspaces as given environment names
  EOF
  type        = list(string)

  validation {
    condition     = length(var.workspace_environment_names) > 0 && alltrue([
      for dp in var.workspace_environment_names : dp != ""
    ])
    error_message = "The workspace_environment_names list must contain at least one non-empty string."
  }
}

variable "root_bucket_name" {
  description = "Name of the root bucket for the workspace, e.g. 'myworkspace-root-bucket'. It can be one already in use by other workspaces"
  type        = string

  validation {
    condition     = trimspace(var.root_bucket_name) != ""
    error_message = "The root_bucket_name value must be a non-empty string."
  }
}

variable "create_root_bucket" {
  description = "Whether to create and configure the root bucket. If false, the module will assume that root_bucket_name belongs to a valid root bucket that thas been already created by the module"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS Region in which to provision the workspace, e.g. eu-west-1"
  type        = string

  validation {
    condition     = trimspace(var.aws_region) != ""
    error_message = "The aws_region value must be a non-empty string."
  }
}

variable "databricks_account_id" {
  description = "Databricks account ID under which to provision the workspace"
  type        = string

  validation {
    condition     = length(var.databricks_account_id) == 36
    error_message = "The databricks_account_id value must be a valid UUID."
  }
}

variable "default_tags" {
  description = "(optional) Tags to be set by default in all resources created for the workspace"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC in which to provision the workspace. The VPC must have a valid Internet Gateway"
  type        = string

  validation {
    condition     = trimspace(var.vpc_id) != ""
    error_message = "The vpc_id value must be a non-empty string."
  }
}

variable "subnets" {
  description = <<EOF
List of subnet definitions per Availability Zone.
Each one will create two subnets:
- Databricks Compute Resources subnet: each compute resource takes two IPs, so a good range of IPs would be from 512 to 4096, depending on specific needs
- NAT Gateway: each NAT subnet takes just one IP, so a /24 CIDR is more than enough
A minimum of two list items in different Availability Zones are required
Note: Internet access is required for Databricks clusters to work. Every NAT Gateway will require an available EIP and a default Internet Gateway in the VPC.
EOF
  type = list(object({
    main_subnet_cidr_block = string
    nat_subnet_cidr_block  = string
    availability_zone      = string
  }))
}

variable "security_groups_to_allow_egress_to" {
  description = "(Optional) List of security group IDs to allow egress to within the VPC"
  type        = list(string)
  nullable    = true
  default     = null

  validation {
    condition     = var.security_groups_to_allow_egress_to == null ? true : [for sg in var.security_groups_to_allow_egress_to : sg if length(trimspace(sg)) == 0] == []
    error_message = "The security_groups_to_allow_egress_to values must contain non-empty string only."
  }
}


variable "security_group_egress_ports" {
  description = <<EOF
(Optional) List of custom ports to allow TCP egress access to 0.0.0.0/0 outside security group.
No need to specify ports 443, 3306 and 6666 as they will be open by default, as recommended by Databricks
EOF
  type        = list(number)
  default     = []

  validation {
    condition     = length(var.security_group_egress_ports) == 0 ? true : min(var.security_group_egress_ports...) > 0 && max(var.security_group_egress_ports...) <= 65535
    error_message = "The security_group_egress_ports values must be in the range (1, 65535)."
  }
}

variable "vpc_endpoints" {
  description = <<EOF
(Optional) List of VPC endpoints to create. The valid values are 's3', 'kinesis-streams' and 'sts'.
If not specified, no VPC endpoints will be created. It is recommended to create all where possible.
More info: https://docs.databricks.com/administration-guide/cloud-configurations/aws/customer-managed-vpc.html#regional-endpoints-1
EOF
  type        = map(bool)
  default = {
    s3              = false
    sts             = false
    kinesis-streams = false
  }

  validation {
    condition     = length(setsubtract(keys(var.vpc_endpoints), ["s3", "sts", "kinesis-streams"])) == 0
    error_message = "The vpc_endpoints valid values are s3, sts and kinesis-streams."
  }
}
