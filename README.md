## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_global"></a> [global](#module\_global) | ./module_global | n/a |
| <a name="module_repos"></a> [repos](#module\_repos) | ./module_repos | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_email"></a> [billing\_email](#input\_billing\_email) | n/a | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | n/a | `map(string)` | n/a | yes |
| <a name="input_organization_secrets"></a> [organization\_secrets](#input\_organization\_secrets) | n/a | `map(string)` | n/a | yes |
| <a name="input_repositories"></a> [repositories](#input\_repositories) | n/a | <pre>map(object({<br>    visibility                      = optional(string, "private")<br>    auto_init                       = optional(bool, true)<br>    archived                        = optional(bool, false)<br>    description                     = optional(string, "")<br>    homepage_url                    = optional(string, "")<br>    is_template                     = optional(bool, false)<br>    teams                           = optional(list(string))<br>    required_status_checks_contexts = optional(list(string))<br>    action_secrets                  = optional(map(string), {})<br>    pages = optional(object({<br>      branch = optional(string)<br>      path   = optional(string)<br>    }))<br>    template = optional(object({<br>      owner      = optional(string)<br>      repository = optional(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_teams"></a> [teams](#input\_teams) | n/a | <pre>map(object({<br>    members = optional(list(string))<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
