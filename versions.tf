terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = ">= 0.5.7"
    }
  }
  required_version = ">= 1.1.2"
}
