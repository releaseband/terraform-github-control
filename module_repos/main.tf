data "github_team" "main" {
  for_each = can(var.teams) && var.teams != null ? { for team in var.teams : team => team } : {}
  slug     = each.key
}

# data "github_app" "name" {
#   for_each = { for actor in var.bypass_actors : actor.name => actor }  
#   slug     = each.key
# }

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
  for_each      = var.protected_branch ? toset(["main"]) : toset([])
  repository_id = github_repository.main.name
  pattern       = each.key
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
  for_each      = var.protected_branch ? toset(["v*.*.*"]) : toset([])
  repository_id = github_repository.main.name
  pattern       = each.key
}

# locals {
#   team_actors = [for actor in var.bypass_actors : actor if actor.actor_type == "Team"]
#   app_actors  = [for actor in var.bypass_actors : actor if actor.actor_type == "App"]
#   # role_actors = [for actor in var.bypass_actors : actor if actor.actor_type == "Role"]

#   team_ids = { for actor in local.team_actors : actor.name => data.github_team.team[actor.name].id }
#   app_ids  = { for actor in local.app_actors : actor.name => data.github_app.app[actor.name].id }
#   # role_ids = { for actor in local.role_actors : actor.name => data.github_role.role[actor.name].id }
# }

resource "github_repository_ruleset" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each      = var.repository_ruleset ? toset(["main"]) : toset([])
  name        = each.key
  repository  = github_repository.main.name
  target      = "branch"
  enforcement = "active"
  # dynamic "bypass_actors" {
  #   for_each   = { for actor in var.bypass_actors : actor.name => actor }
  #   content {
  #     actor_type = bypass_actors.value.actor_type
  #     actor_id    = bypass_actors.value.actor_type == "Team" ? local.team_ids[bypass_actors.key] : bypass_actors.value.actor_type == "App" ? local.app_ids[bypass_actors.key] : local.role_ids[bypass_actors.key]
  #     bypass_mode = "always"
  #   }
  # }
  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }
  rules {
    deletion = true
    dynamic "required_status_checks" {
      for_each = can(var.required_status_checks_contexts) && var.required_status_checks_contexts == null ? [] : [var.required_status_checks_contexts]
      content {
        dynamic "required_check" {
          for_each = var.required_status_checks_contexts
          content {
           context = required_check.value
          }
        }
        strict_required_status_checks_policy = false
      }
    }
    pull_request {
      require_code_owner_review       = true
      required_approving_review_count = 0
    }
    non_fast_forward = true
  }
}



resource "github_team_repository" "main" {
  depends_on = [
    github_repository.main
  ]
  for_each   = { for team in data.github_team.main : team.slug => team }
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
  for_each   = var.collaborators
  repository = github_repository.main.name
  username   = each.key
  permission = each.value
}
