resource "databricks_mws_credentials" "this" {
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${var.resource_prefix}-${var.workspace}-creds"
  depends_on       = [time_sleep.wait]
}

resource "databricks_mws_networks" "this" {
 
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace}-network"
  security_group_ids = [aws_security_group.this.id]
  subnet_ids         = [for k, v in aws_subnet.databricks_subnets : v.id]
  vpc_id             = var.vpc_id
}

resource "databricks_mws_storage_configurations" "this" {
  account_id                 = var.databricks_account_id
  bucket_name                = var.create_root_bucket ? aws_s3_bucket.root_storage_bucket[0].bucket : var.root_bucket_name
  storage_configuration_name = "${var.resource_prefix}-${var.workspace}-storage"
}

resource "time_sleep" "wait" {
  depends_on      = [aws_iam_role.cross_account_role, aws_iam_role_policy.this]
  create_duration = "20s"
}
