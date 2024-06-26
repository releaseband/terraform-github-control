variable "name" {
  type = string
}
variable "visibility" {
  type    = string
  default = "private"
}
variable "auto_init" {
  type    = bool
  default = true
}
variable "archived" {
  type    = bool
  default = false
}
variable "description" {
  type    = string
  default = ""
}
variable "homepage_url" {
  type    = string
  default = ""
}
variable "is_template" {
  type    = bool
  default = false
}
variable "teams" {
  type = list(string)
}
variable "collaborators" {
  type    = map(string)
  default = {}
}
variable "required_status_checks_contexts" {
  type = list(string)
}
variable "action_secrets" {
  type    = map(string)
  default = {}
}
variable "pages" {
  type = object({
    branch = optional(string)
    path   = optional(string)
  })
  default = null
}
variable "template" {
  type = object({
    owner      = optional(string)
    repository = optional(string)
  })
  default = null
}
variable "protected_branch" {
  type = bool
}
variable "repository_ruleset" {
  type = bool
}
variable "bypass_actors" {
  type = map(object({
    bypass_mode = string
    actor_type  = string
    actor       = string
    role_id     = number
  }))
}
variable "preparing_environments" {
  type = bool
  default = true
}
variable "environments" {
  type = list(string)
  default = [ "dev","stage", "prod" ]
}
variable "env_secrets_dev" {
  type = map(string)
  default = {}
}
variable "env_secrets_stage" {
  type = map(string)
  default = {}
}
variable "env_secrets_prod" {
  type = map(string)
  default = {}
}

# OrganizationAdmin
# RepositoryRole (This is the actor type, the following are the base repository roles and their associated IDs.)
# maintain -> 2
# write -> 4
# admin -> 5
# OrganizationAdmin -> 1
