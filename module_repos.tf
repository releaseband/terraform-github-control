module "repo" {
  for_each                        = var.repositories
  source                          = "./module_repos"
  auto_init                       = each.value["auto_init"]
  name                            = each.key
  visibility                      = each.value["visibility"]
  archived                        = each.value["archived"]
  description                     = each.value["description"]
  is_template                     = each.value["is_template"]
  homepage_url                    = each.value["homepage_url"]
  pages                           = each.value["pages"]
  template                        = each.value["template"]
  protected_branch                = each.value["protected_branch"]
  repository_ruleset              = each.value["repository_ruleset"]
  # bypass_actors                   = each.value["bypass_actors"]
  required_status_checks_contexts = each.value["required_status_checks_contexts"]
  teams                           = each.value["teams"]
  collaborators                   = each.value["collaborators"]
  action_secrets                  = each.value["action_secrets"]
}
