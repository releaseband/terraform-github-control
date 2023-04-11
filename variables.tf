variable "repositories" {
  type = map(object({
    visibility                      = optional(string, "private")
    auto_init                       = optional(bool, true)
    archived                        = optional(bool, false)
    description                     = optional(string, "")
    homepage_url                    = optional(string, "")
    is_template                     = optional(bool, false)
    teams                           = optional(list(string))
    required_status_checks_contexts = optional(list(string))
    pages = optional(object({
      branch = optional(string)
      path   = optional(string)
    }))
    template = optional(object({
      owner      = optional(string)
      repository = optional(string)
    }))
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
