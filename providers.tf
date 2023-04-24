terraform {
  required_version = ">= 1.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.18.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.64.0"
    }
  }
}