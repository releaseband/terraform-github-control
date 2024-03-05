# Submodule of Global settings
Using this submodule for manage the basic and main settings of the GitHub organization.
Manage organization members, groups, secrets, and other level settings.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | n/a |


## Resources

| Name | Type |
|------|------|
| [github_actions_organization_secret.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret) | resource |
| [github_membership.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership) | resource |
| [github_organization_settings.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_settings) | resource |
| [github_team.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team) | resource |
| [github_team_members.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members) | resource |
| [github_team_settings.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_settings) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_email"></a> [billing\_email](#input\_billing\_email) | n/a | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | n/a | `map(string)` | n/a | yes |
| <a name="input_organization_secrets"></a> [organization\_secrets](#input\_organization\_secrets) | n/a | `map(string)` | n/a | yes |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | <pre>map(object({<br>    members = optional(list(string))<br>  }))</pre> | n/a | yes |
