output "databricks_host" {
  description = "Databricks workspace URL for the given created workspace."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "databricks_token" {
  description = "Databricks workspace tokens. Usage is now between limited and unusable. Can't be used to create resources in the workspace when Unity Catalog is not enabled. If UC is enabled, the recommended way is to create a Service Principal and a secret, assign it to the workspace and use it instead."
  value       = databricks_mws_workspaces.this.token[0].token_value
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the security group created for the Databricks workspace"
  value       = aws_security_group.this.id
}

output "cross_account_role_name" {
  description = "Name of the cross-account IAM role created for the Databricks workspace"
  value       = aws_iam_role.cross_account_role.name
}
