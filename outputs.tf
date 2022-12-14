output "databricks_hosts" {
  description = "Databricks workspace URLs for the given created workspaces."
  value       = {for k, workspace in databricks_mws_workspaces.these: k => workspace.workspace_url}
}

output "databricks_tokens" {
  description = "Databricks workspace tokens for the given created workspaces. Can be used to create resources in the workspace in the same Terraform state."
  value       = {for k, workspace in databricks_mws_workspaces.these: k => workspace.token[0].token_value}
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
