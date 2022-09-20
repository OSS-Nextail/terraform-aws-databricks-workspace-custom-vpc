variable "databricks_account_username" {
  type      = string
  sensitive = true
}

variable "databricks_account_password" {
  type      = string
  sensitive = true
}

variable "databricks_account_id" {
  type      = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}