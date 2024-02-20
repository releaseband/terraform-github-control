module "repos" {
  source = "./module_repos"
  config = local.repos_config
}
locals {
  repos_config = {
    repositories = var.repositories
    teams        = module.global.github_teams
  }
}
