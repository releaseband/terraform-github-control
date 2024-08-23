variable "repositories" {
  type = map(object({
    visibility         = optional(string, "private")
    auto_init          = optional(bool, true)
    archived           = optional(bool, false)
    description        = optional(string, "")
    homepage_url       = optional(string, "")
    is_template        = optional(bool, false)
    teams              = optional(list(string))
    collaborators      = optional(map(string), {})
    protected_branch   = optional(bool, false)
    repository_ruleset = optional(bool, true)
    bypass_actors = optional(map(object({
      bypass_mode = optional(string, "always")
      actor_type  = optional(string)
      actor       = optional(string)
      role_id     = optional(number, 2)
    })))
    required_status_checks_contexts = optional(list(string))
    action_secrets                  = optional(map(string), {})
    pages = optional(object({
      branch = optional(string)
      path   = optional(string)
    }))
    template = optional(object({
      owner      = optional(string)
      repository = optional(string)
    }))
    preparing_environments = optional(bool, false)
    env_secrets_dev        = optional(map(string), {})
    env_secrets_stage      = optional(map(string), {})
    env_secrets_prod       = optional(map(string), {})
    env_variables_dev      = optional(map(string), {})
    env_variables_stage    = optional(map(string), {})
    env_variables_prod     = optional(map(string), {})
  }))
}

variable "members" {
  type = map(string)
}

variable "billing_email" {
  type = string
}

variable "teams" {
  type = map(object({
    members = optional(list(string))
  }))
}

variable "organization_secrets" {
  type = map(string)
}
