module "global" {
  source               = "./module_global"
  billing_email        = var.billing_email
  teams                = var.teams
  members              = var.members
  organization_secrets = var.organization_secrets
}
