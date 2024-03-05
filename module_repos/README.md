# Submodule of Repositories settings
Use this submodule to manage repository settings. Add groups to repositories, as well as repository permissions for specific users.
Set default branches and protected branches.


## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | n/a |


## Resources

| Name | Type |
|------|------|
| [github_actions_secret.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_branch_default.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_branch_protection.versions](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_team_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team.main](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_secrets"></a> [action\_secrets](#input\_action\_secrets) | n/a | `map(string)` | `{}` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | n/a | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | n/a | `bool` | `true` | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | n/a | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `""` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | n/a | `string` | `""` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | n/a | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | n/a | <pre>object({<br>    branch = optional(string)<br>    path   = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_required_status_checks_contexts"></a> [required\_status\_checks\_contexts](#input\_required\_status\_checks\_contexts) | n/a | `list(string)` | n/a | yes |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | `list(string)` | n/a | yes |
| <a name="input_template"></a> [template](#input\_template) | n/a | <pre>object({<br>    owner      = optional(string)<br>    repository = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | n/a | `string` | `"private"` | no |
