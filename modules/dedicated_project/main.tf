# modules/dedicated_project/main.tf

# Create Google Cloud Project
resource "google_project" "project" {
  name                = var.project_id
  project_id          = var.project_id
  org_id              = data.google_organization.organization.org_id
  billing_account     = local.billing_account
  auto_create_network = false
  labels              = var.labels
}