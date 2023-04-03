variable "repositories" {
  type = map(object({
    visibility   = optional(string)
    archived     = optional(bool)
    description  = optional(string)
    homepage_url = optional(string)
    teams        = optional(list(string))
    pages = optional(object({
      branch = optional(string)
      path   = optional(string)
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
