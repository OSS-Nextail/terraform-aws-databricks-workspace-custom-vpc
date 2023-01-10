data "databricks_aws_assume_role_policy" "assume_cross_acount_role" {
  external_id = var.databricks_account_id
}

resource "aws_iam_role" "cross_account_role" {
  name               = "${var.resource_prefix}-${var.workspace}-crossaccount"
  assume_role_policy = data.databricks_aws_assume_role_policy.assume_cross_acount_role.json
  tags               = var.default_tags
}

data "databricks_aws_crossaccount_policy" "this" {
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.resource_prefix}-${var.workspace}-policy"
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}
