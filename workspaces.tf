locals {
  workspace_environment_names = var.workspace_environment_names
}

resource "databricks_mws_workspaces" "this" {
  for_each        = toset(local.workspace_environment_names)
  
  account_id      = var.databricks_account_id
  aws_region      = var.aws_region
  workspace_name  = each.key
  deployment_name = each.key

  credentials_id           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id               = databricks_mws_networks.this.network_id

  token {
    comment = "Terraform"
  }
}
