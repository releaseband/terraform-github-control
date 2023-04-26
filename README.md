<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 5.18.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 5.18.3 |

## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_actions_secret.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_branch_default.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_branch_protection.versions](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_membership.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership) | resource |
| [github_organization_settings.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings) | resource |
| [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_team.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team) | resource |
| [github_team_members.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members) | resource |
| [github_team_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team_settings.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_email"></a> [billing\_email](#input\_billing\_email) | n/a | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | n/a | `map(string)` | n/a | yes |
| <a name="input_organization_secrets"></a> [organization\_secrets](#input\_organization\_secrets) | n/a | `map(string)` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | n/a | <pre>map(object({<br>    visibility                      = optional(string, "private")<br>    auto_init                       = optional(bool, true)<br>    archived                        = optional(bool, false)<br>    description                     = optional(string, "")<br>    homepage_url                    = optional(string, "")<br>    is_template                     = optional(bool, false)<br>    teams                           = optional(list(string))<br>    required_status_checks_contexts = optional(list(string))<br>    action_secrets                  = optional(map(string), {})<br>    pages = optional(object({<br>      branch = optional(string)<br>      path   = optional(string)<br>    }))<br>    template = optional(object({<br>      owner      = optional(string)<br>      repository = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | <pre>map(object({<br>    members = optional(list(string))<br>  }))</pre> | n/a | yes |
<!-- END_TF_DOCS -->