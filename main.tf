resource "github_repository" "main" {
  for_each               = var.repositories
  auto_init              = true
  name                   = each.key
  visibility             = try(each.value["visibility"], "private")
  archived               = try(each.value["archived"], false)
  description            = try(each.value["description"], "")
  has_downloads          = true
  has_issues             = true
  has_projects           = true
  has_wiki               = true
  delete_branch_on_merge = true
  vulnerability_alerts   = true
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_auto_merge       = false
  allow_update_branch    = true
  security_and_analysis {
    advanced_security {
      status = each.value["visibility"] != "public" ? "disabled" : "enabled"
    }
    secret_scanning {
      status = each.value["visibility"] != "public" ? "disabled" : "enabled"
    }
    secret_scanning_push_protection {
      status = each.value["visibility"] != "public" ? "disabled" : "enabled"
    }
  }
  homepage_url = try(each.value["homepage_url"], "")
  dynamic "pages" {
    for_each = each.value["pages"] == null ? [] : [each.value["pages"]]
    content {
      source {
        branch = try(pages.value["branch"], "main")
        path   = try(pages.value["path"], "/")
      }
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

resource "github_branch_protection_v3" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each   = var.repositories
  repository = github_repository.main[each.key].name
  branch     = "main"
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
