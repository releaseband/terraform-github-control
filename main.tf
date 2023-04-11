resource "github_repository" "main" {
  for_each               = var.repositories
  auto_init              = each.value["auto_init"]
  name                   = each.key
  visibility             = each.value["visibility"]
  archived               = each.value["archived"]
  description            = each.value["description"]
  has_downloads          = true
  has_issues             = true
  has_projects           = true
  has_wiki               = false
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_auto_merge       = false
  allow_update_branch    = true
  is_template            = each.value["is_template"]
  homepage_url           = each.value["homepage_url"]
  dynamic "pages" {
    for_each = each.value["pages"] == null ? [] : [each.value["pages"]]
    content {
      source {
        branch = try(pages.value["branch"], "main")
        path   = try(pages.value["path"], "/")
      }
    }
  }
  dynamic "template" {
    for_each = each.value["template"] == null ? [] : [each.value["template"]]
    content {
      owner      = try(template.value["owner"], "")
      repository = try(template.value["repository"], "")
    }
  }
}


resource "github_branch_default" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each   = var.repositories
  repository = github_repository.main[each.key].name
  branch     = "main"
}

resource "github_branch_protection" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each      = var.repositories
  repository_id = github_repository.main[each.key].name
  pattern       = "main"
  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = false
    require_last_push_approval      = false
    required_approving_review_count = 0 #var.teams[each.value["teams"][0]]["members"] == null ? 1 : length(var.teams[each.value["teams"][0]]["members"])
    restrict_dismissals             = false
  }
  dynamic "required_status_checks" {
    for_each = each.value["required_status_checks_contexts"] == null ? [] : [each.value["required_status_checks_contexts"]]
    content {
      contexts = each.value["required_status_checks_contexts"]
      strict   = false
    }
  }
}

resource "github_branch_protection" "versions" {
  for_each      = var.repositories
  repository_id = github_repository.main[each.key].name
  pattern       = "v*.*.*"
}



resource "github_membership" "main" {
  for_each = var.members
  username = each.key
  role     = each.value
}

resource "github_organization_settings" "main" {
  billing_email                                                = var.billing_email
  has_organization_projects                                    = true
  has_repository_projects                                      = true
  default_repository_permission                                = "read"
  members_can_create_repositories                              = false
  members_can_create_public_repositories                       = false
  members_can_create_private_repositories                      = false
  members_can_create_internal_repositories                     = false
  members_can_create_pages                                     = true
  members_can_create_public_pages                              = true
  members_can_create_private_pages                             = true
  members_can_fork_private_repositories                        = false
  web_commit_signoff_required                                  = true
  advanced_security_enabled_for_new_repositories               = false
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = false
  secret_scanning_push_protection_enabled_for_new_repositories = false
}

resource "github_team" "main" {
  for_each = var.teams
  name     = each.key
  privacy  = "closed"
}

resource "github_team_members" "main" {
  for_each = var.teams
  team_id  = github_team.main[each.key].id

  dynamic "members" {
    for_each = each.value["members"]
    content {
      username = members.value
      role     = "maintainer"
    }
  }
}

resource "github_team_settings" "main" {
  for_each = var.teams
  team_id  = github_team.main[each.key].id
  review_request_delegation {
    algorithm    = "ROUND_ROBIN"
    member_count = length(each.value["members"])
    notify       = true
  }
}

locals {
  repositories_teams_flatten = flatten([
    for i, item in var.repositories : [
      for pair in setproduct([item], item.teams == null ? [] : item.teams) : {
        repository = "${i}"
        team       = pair[1]
      }
    ]
  ])
  repositories_teams = {
    for i, item in local.repositories_teams_flatten : "${item.repository}-${item.team}" => item
  }
}


resource "github_team_repository" "main" {
  for_each   = local.repositories_teams
  team_id    = github_team.main[each.value.team].id
  repository = github_repository.main[each.value.repository].name
  permission = "push"
}

# generate ssh key for each repository
# TODO : use github actions secret instead of tls_private_key
# resource "tls_private_key" "main" {
#   for_each  = var.repositories
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "github_repository_deploy_key" "main" {
#   for_each   = var.repositories
#   repository = github_repository.main[each.key].name
#   title      = "actions"
#   key        = tls_private_key.main[each.key].public_key_openssh
#   read_only  = false
# }

# resource "github_actions_secret" "main" {
#   for_each        = var.repositories
#   repository      = github_repository.main[each.key].name
#   secret_name     = "ACTIONS_SSH_KEY"
#   plaintext_value = tls_private_key.main[each.key].private_key_pem
# }

resource "github_actions_organization_secret" "main" {
  for_each        = var.organization_secrets
  secret_name     = each.key
  visibility      = "all"
  plaintext_value = each.value
}



