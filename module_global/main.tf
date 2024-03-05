resource "github_organization_settings" "main" {
  billing_email                                                = var.billing_email
  has_organization_projects                                    = true
  has_repository_projects                                      = true
  default_repository_permission                                = "none"
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
resource "github_actions_organization_secret" "main" {
  for_each        = var.organization_secrets
  secret_name     = each.key
  visibility      = "all"
  plaintext_value = each.value
}
resource "github_membership" "main" {
  for_each = var.members
  username = each.key
  role     = each.value
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