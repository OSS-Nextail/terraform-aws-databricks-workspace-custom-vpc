resource "databricks_mws_workspaces" "this" {
 
  account_id      = var.databricks_account_id
  aws_region      = var.aws_region
  workspace_name  = var.workspace
  deployment_name = var.add_deployment_name ? var.workspace : null

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id
}
