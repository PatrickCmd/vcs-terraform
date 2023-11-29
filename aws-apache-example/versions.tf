terraform {
  cloud {
    organization = "PatrickCmdCloud"

    workspaces {
      name = "terraform-vcs"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.28.0"
    }
  }

  required_version = ">= 1.6.4"
}
