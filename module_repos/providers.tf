terraform {
  required_version = ">= 1.4"
  required_providers {
    github = {
      source = "integrations/github"
      version = ">= 5.18.3"
    }
  }
}
