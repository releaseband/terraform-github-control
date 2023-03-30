resource "github_repository" "main" {
  for_each               = var.repositories
  auto_init = true
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
  homepage_url           = try(each.value["homepage_url"], "")
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
  for_each   = var.repositories
  repository = github_repository.main[each.key].name
  branch     = "main"
}

resource "github_branch_protection_v3" "main" {
  for_each   = var.repositories
  repository = github_repository.main[each.key].name
  branch     = "main"
}

resource "github_membership" "main" {
  for_each = var.members
  username = each.key
  role     = each.value
}
