locals {
  workspaces = var.workspaces
  add_deployment_name = var.add_deployment_name
}

resource "databricks_mws_workspaces" "these" {
  for_each        = toset(local.workspaces)
  
  account_id      = var.databricks_account_id
  aws_region      = var.aws_region
  workspace_name  = each.key
  deployment_name = local.add_deployment_name ? each.key : null

  credentials_id           = databricks_mws_credentials.these.credentials_id
  storage_configuration_id = databricks_mws_storage_configurations.these.storage_configuration_id
  network_id               = databricks_mws_networks.these.network_id

  token {
    comment = "Terraform"
  }
}

moved {
  from = databricks_mws_workspaces.this
  to   = databricks_mws_workspaces.these[0]
}