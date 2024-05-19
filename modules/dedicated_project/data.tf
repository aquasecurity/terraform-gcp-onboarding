# modules/dedicated_project/data.tf

# Retrieve information about the Google Cloud project
data "google_project" "root_project" {
  count      = var.type == "single" ? 1 : 0
  project_id = var.root_project_id
}

# Getting organization id
data "google_organization" "organization" {
  domain = var.org_name
}