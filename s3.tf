resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = var.root_bucket_name

  force_destroy = true
  tags = merge(var.default_tags, {
    Name = var.root_bucket_name
  })

  count = var.create_root_bucket ? 1 : 0
}

resource "aws_s3_bucket_versioning" "root_storage_bucket" {
  bucket = aws_s3_bucket.root_storage_bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }

  count = var.create_root_bucket ? 1 : 0
}

resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  bucket             = aws_s3_bucket.root_storage_bucket[0].id
  ignore_public_acls = true
  depends_on         = [aws_s3_bucket.root_storage_bucket[0]]

  count = var.create_root_bucket ? 1 : 0
}

data "databricks_aws_bucket_policy" "root_storage_bucket" {
  bucket = aws_s3_bucket.root_storage_bucket[0].bucket
  count  = var.create_root_bucket ? 1 : 0
}

resource "aws_s3_bucket_policy" "root_bucket_policy" {
  bucket = aws_s3_bucket.root_storage_bucket[0].id
  policy = data.databricks_aws_bucket_policy.root_storage_bucket[0].json

  depends_on = [aws_s3_bucket_public_access_block.root_storage_bucket[0]]

  count = var.create_root_bucket ? 1 : 0
}
