output "databricks_host" {
  description = "Databricks workspace URL for the given created workspace."
  value       = databricks_mws_workspaces.this.workspace_url
}

output "security_group_id" {
  description = "ID of the security group created for the Databricks workspace"
  value       = aws_security_group.this.id
}

output "cross_account_role_name" {
  description = "Name of the cross-account IAM role created for the Databricks workspace"
  value       = aws_iam_role.cross_account_role.name
}
