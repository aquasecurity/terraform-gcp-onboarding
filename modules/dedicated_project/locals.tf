# modules/dedicated_project/locals.tf

locals {
  billing_account = var.type == "single" ? data.google_project.root_project[0].billing_account : var.billing_account_id
}