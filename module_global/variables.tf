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
