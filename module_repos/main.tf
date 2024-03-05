resource "github_repository" "main" {
  auto_init              = var.auto_init
  name                   = var.name
  visibility             = var.visibility
  archived               = var.archived
  description            = var.description
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
  is_template            = var.is_template
  homepage_url           = var.homepage_url
  dynamic "pages" {
    for_each = var.pages == null ? [] : [var.pages]
    content {
      source {
        branch = try(pages.value["branch"], "main")
        path   = try(pages.value["path"], "/")
      }
    }
  }
  dynamic "template" {
    for_each = var.template == null ? [] : [var.template]
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
  count      = var.archived != true ? 1 : 0
  repository = github_repository.main.name
  branch     = "main"
}

resource "github_branch_protection" "main" {
  depends_on = [
    github_repository.main
  ]
  repository_id = github_repository.main.name
  pattern       = "main"
  required_pull_request_reviews {
    dismiss_stale_reviews           = false
    require_code_owner_reviews      = false
    require_last_push_approval      = false
    required_approving_review_count = 0 #var.teams[each.value["teams"][0]]["members"] == null ? 1 : length(var.teams[each.value["teams"][0]]["members"])
    restrict_dismissals             = false
  }
  dynamic "required_status_checks" {
    for_each = var.required_status_checks_contexts == null ? [] : [var.required_status_checks_contexts]
    content {
      contexts = var.required_status_checks_contexts
      strict   = false
    }
  }
}

resource "github_branch_protection" "versions" {
  repository_id = github_repository.main.name
  pattern       = "v*.*.*"
}

data "github_team" "main" {
  for_each = can(var.teams) && var.teams != null ? { for team in var.teams : team => team } : {}
  slug     = each.key
}

resource "github_team_repository" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each   = { for team in data.github_team.main : team.slug => team  }
  team_id    = each.value.id
  repository = github_repository.main.name
  permission = each.value.name == "readonly-team" ? "pull" : "push"
}

resource "github_actions_secret" "main" {
  for_each        = var.action_secrets
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_repository_collaborator" "main" {
  for_each = var.collaborators
  repository = github_repository.main.name
  username   = each.key
  permission = each.value
}