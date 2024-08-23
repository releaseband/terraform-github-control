data "github_team" "main" {
  for_each = can(var.teams) && var.teams != null ? { for team in var.teams : team => team } : {}
  slug     = each.key
}

data "github_app" "main" {
  for_each = can(var.bypass_actors) && var.bypass_actors != null ? { for k, v in var.bypass_actors : k => v if can(v["actor"]) && v["actor_type"] == "Integration" && v["actor"] != null } : {}
  slug     = each.value["actor"]
}

resource "github_repository" "main" {
  auto_init                   = var.auto_init
  name                        = var.name
  visibility                  = var.visibility
  archived                    = var.archived
  description                 = var.description
  has_downloads               = true
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  delete_branch_on_merge      = true
  vulnerability_alerts        = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_auto_merge            = false
  allow_update_branch         = true
  is_template                 = var.is_template
  homepage_url                = var.homepage_url
  web_commit_signoff_required = true
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
# condition: if protected_branch=true then repository_ruleset=false  - forced.
locals {
  repository_ruleset = var.protected_branch ? false : var.repository_ruleset
}
resource "github_branch_protection" "main" {
  depends_on = [
    github_repository.main
  ]
  # if protected_branch=true and repository_ruleset=false , then go ahead
  for_each      = var.protected_branch && local.repository_ruleset == false ? toset(["main", "v*.*.*"]) : toset([]) # 
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
resource "github_repository_ruleset" "main" {
  depends_on = [
    github_repository.main
  ]
  # if protected_branch=false (default value) and repository_ruleset=true (default value) , then go ahead
  for_each    = var.protected_branch == false && var.repository_ruleset ? toset(["main"]) : toset([])
  name        = each.key
  repository  = github_repository.main.name
  target      = "branch"
  enforcement = "active"
  dynamic "bypass_actors" {
    for_each = var.bypass_actors != null ? var.bypass_actors : {}
    content {
      actor_type  = bypass_actors.value["actor_type"]
      actor_id    = bypass_actors.value["actor_type"] == "Team" ? data.github_team.main[bypass_actors.value["actor"]].id : bypass_actors.value["actor_type"] == "RepositoryRole" ? bypass_actors.value["role_id"] : data.github_app.main[bypass_actors.key].id
      bypass_mode = bypass_actors.value["bypass_mode"]
    }
  }
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

resource "github_repository_environment" "main" {
  for_each    = var.preparing_environments ? { for preparing_environments in var.environments : preparing_environments => true } : {}
  repository  = github_repository.main.name
  environment = each.key
}


resource "github_actions_environment_secret" "dev" {
  for_each        = var.env_secrets_dev != null ? var.env_secrets_dev : {}
  environment     = "dev"
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value
}
resource "github_actions_environment_variable" "dev" {
  for_each      = var.env_variables_dev != null ? var.env_variables_dev : {}
  environment   = "dev"
  repository    = github_repository.main.name
  variable_name = each.key
  value         = each.value
}
resource "github_actions_environment_secret" "stage" {
  for_each        = var.env_secrets_stage != null ? var.env_secrets_stage : {}
  environment     = "stage"
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value
}
resource "github_actions_environment_variable" "stage" {
  for_each      = var.env_variables_stage != null ? var.env_variables_stage : {}
  environment   = "stage"
  repository    = github_repository.main.name
  variable_name = each.key
  value         = each.value
}
resource "github_actions_environment_secret" "prod" {
  for_each        = var.env_secrets_prod != null ? var.env_secrets_prod : {}
  environment     = "prod"
  repository      = github_repository.main.name
  secret_name     = each.key
  plaintext_value = each.value
}
resource "github_actions_environment_variable" "prod" {
  for_each      = var.env_variables_prod != null ? var.env_variables_prod : {}
  environment   = "prod"
  repository    = github_repository.main.name
  variable_name = each.key
  value         = each.value
}