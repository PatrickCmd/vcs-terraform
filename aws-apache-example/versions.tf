terraform {
  required_version = ">= 1.6.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.28.0"
    }
  }
}
