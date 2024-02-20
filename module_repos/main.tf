resource "github_repository" "main" {
  for_each               = var.config.repositories
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
  for_each   = { for k, v in var.config.repositories : k => v if v.archived != true }
  repository = github_repository.main[each.key].name
  branch     = "main"
}

resource "github_branch_protection" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each      = var.config.repositories
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
  for_each      = var.config.repositories
  repository_id = github_repository.main[each.key].name
  pattern       = "v*.*.*"
}
locals {
  repositories_teams_flatten = flatten([
    for i, item in var.config.repositories : [
      for pair in setproduct([item], item.teams == null ? [] : item.teams) : {
        repository = "${i}"
        team       = pair[1]
      }
    ]
  ])
  repositories_secrets_flatten = flatten([
    for i, item in var.config.repositories : [
      for data in setproduct([item], keys(item.action_secrets)) : {
        repository      = "${i}"
        secret_name     = data[1]
        plaintext_value = lookup(item.action_secrets, data[1])
      }
    ]
  ])
  repositories_teams = {
    for i, item in local.repositories_teams_flatten : "${item.repository}-${item.team}" => item
  }
  repositories_secrets = {
    for i, item in local.repositories_secrets_flatten : "${item.repository}-${lower(item.secret_name)}" => item
  }
}
resource "github_team_repository" "main" {
  for_each   = local.repositories_teams
  team_id    = var.config.teams[each.value.team].id
  repository = github_repository.main[each.value.repository].name
  permission = var.config.teams[each.value.team].name == "readonly-team" ? "pull" : "push"
}
resource "github_actions_secret" "main" {
  for_each        = local.repositories_secrets
  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = each.value.plaintext_value
}