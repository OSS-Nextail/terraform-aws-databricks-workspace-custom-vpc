# terraform-aws-databricks-workspace-custom-vpc

Nextail Terraform module for creating a Databricks workspace in AWS within an existing VPC

## Releasing a new version

1. Run `make update-docs` and commit updated README
2. Tag the commit with the proper version

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.37.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.37.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 1.0.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc_endpoints"></a> [vpc\_endpoints](#module\_vpc\_endpoints) | terraform-aws-modules/vpc/aws//modules/vpc-endpoints | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.databricks_nat_gateways_eips](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_role.cross_account_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_nat_gateway.databricks_nat_gateways](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.databricks_main_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.databricks_nat_route_tables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.databricks_main_route_tables_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.databricks_nat_route_tables_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.root_storage_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.root_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.root_storage_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.root_storage_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.databricks_nat_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.databricks_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [databricks_mws_credentials.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_credentials) | resource |
| [databricks_mws_networks.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_networks) | resource |
| [databricks_mws_storage_configurations.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_storage_configurations) | resource |
| [databricks_mws_workspaces.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces) | resource |
| [time_sleep.wait](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_internet_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/internet_gateway) | data source |
| [databricks_aws_assume_role_policy.assume_cross_acount_role](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_assume_role_policy) | data source |
| [databricks_aws_bucket_policy.root_storage_bucket](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_bucket_policy) | data source |
| [databricks_aws_crossaccount_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/data-sources/aws_crossaccount_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_deployment_name"></a> [add\_deployment\_name](#input\_add\_deployment\_name) | Whether to add the workspace name as a deployment name. Capability of adding deployment name must be provided by Databricks: <br>  https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces#deployment_name | `bool` | `true` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region in which to provision the workspace, e.g. eu-west-1 | `string` | n/a | yes |
| <a name="input_create_root_bucket"></a> [create\_root\_bucket](#input\_create\_root\_bucket) | Whether to create and configure the root bucket. If false, the module will assume that root\_bucket\_name belongs to a valid root bucket that thas been already created by the module | `bool` | `true` | no |
| <a name="input_databricks_account_id"></a> [databricks\_account\_id](#input\_databricks\_account\_id) | Databricks account ID under which to provision the workspace | `string` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | (optional) Tags to be set by default in all resources created for the workspace | `map(string)` | `{}` | no |
| <a name="input_external_security_group_egress_ports"></a> [external\_security\_group\_egress\_ports](#input\_external\_security\_group\_egress\_ports) | (Optional) List of custom ports to allow TCP egress access to 0.0.0.0/0 outside security group.<br>No need to specify ports 443, 3306 and 6666 as they will be open by default, as recommended by Databricks | `list(number)` | `[]` | no |
| <a name="input_external_security_groups_to_allow_ingress_from"></a> [external\_security\_groups\_to\_allow\_ingress\_from](#input\_external\_security\_groups\_to\_allow\_ingress\_from) | (Optional) List of security group IDs to allow ingress from outside the VPC for the recommended Databricks ports:<br>- 2200 (SSH) | `list(string)` | `[]` | no |
| <a name="input_internal_security_groups_to_allow_egress_to"></a> [internal\_security\_groups\_to\_allow\_egress\_to](#input\_internal\_security\_groups\_to\_allow\_egress\_to) | (Optional) List of security group IDs to allow egress to within the VPC | `list(string)` | `[]` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | Prefix to apply in the names of shared AWS resources to be created for the workspace | `string` | n/a | yes |
| <a name="input_root_bucket_name"></a> [root\_bucket\_name](#input\_root\_bucket\_name) | Name of the root bucket for the workspace, e.g. 'myworkspace-root-bucket'. It can be one already in use by other workspaces | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet definitions per Availability Zone.<br>Each one will create two subnets:<br>- Databricks Compute Resources subnet: each compute resource takes two IPs, so a good range of IPs would be from 512 to 4096, depending on specific needs<br>- NAT Gateway: each NAT subnet takes just one IP, so a /24 CIDR is more than enough<br>A minimum of two list items in different Availability Zones are required<br>Note: Internet access is required for Databricks clusters to work. Every NAT Gateway will require an available EIP and a default Internet Gateway in the VPC. | <pre>list(object({<br>    main_subnet_cidr_block = string<br>    nat_subnet_cidr_block  = string<br>    availability_zone      = string<br>  }))</pre> | n/a | yes |
| <a name="input_token_lifetime_seconds"></a> [token\_lifetime\_seconds](#input\_token\_lifetime\_seconds) | (Optional) Generated token expiry lifetime. By default it is 2592000 (30 days). NOTE: this token won't be valid for workspace management in Databricks accounts without Unity Catalog enabled. | `number` | `2592000` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | (Optional) List of VPC endpoints to create. The valid values are 's3', 'kinesis-streams' and 'sts'.<br>If not specified, no VPC endpoints will be created. It is recommended to create all where possible.<br>More info: https://docs.databricks.com/administration-guide/cloud-configurations/aws/customer-managed-vpc.html#regional-endpoints-1 | `map(bool)` | <pre>{<br>  "kinesis-streams": false,<br>  "s3": false,<br>  "sts": false<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC in which to provision the workspace. The VPC must have a valid Internet Gateway | `string` | n/a | yes |
| <a name="input_workspace"></a> [workspace](#input\_workspace) | Databricks workspace name. Optionally will be used as deployment name, if add\_deployment\_name is true. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role_name"></a> [cross\_account\_role\_name](#output\_cross\_account\_role\_name) | Name of the cross-account IAM role created for the Databricks workspace |
| <a name="output_databricks_host"></a> [databricks\_host](#output\_databricks\_host) | Databricks workspace URL for the given created workspace. |
| <a name="output_databricks_token"></a> [databricks\_token](#output\_databricks\_token) | Databricks workspace tokens. Usage is now between limited and unusable. Can't be used to create resources in the workspace when Unity Catalog is not enabled. If UC is enabled, the recommended way is to create a Service Principal and a secret, assign it to the workspace and use it instead. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group created for the Databricks workspace |
<!-- END_TF_DOCS -->
