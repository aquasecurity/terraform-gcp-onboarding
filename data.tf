# data.tf

# Retrieve information about the Google Cloud organization
data "google_organization" "organization" {
  count  = var.dedicated_project ? 1 : 0
  domain = var.org_name
}

# Retrieve information about the root Google Cloud project
data "google_project" "project" {
  project_id = var.project_id
}


