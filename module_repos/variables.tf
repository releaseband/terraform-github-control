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
