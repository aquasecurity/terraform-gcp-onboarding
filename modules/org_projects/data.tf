# modules/org_projects/data.tf

# Retrieve information about the Google Cloud organization
data "google_organization" "org" {
  domain = var.org_name
}

# Search for all active projects within the organization
data "google_cloud_asset_search_all_resources" "all_projects" {
  scope       = "organizations/${data.google_organization.org.org_id}"
  asset_types = ["cloudresourcemanager.googleapis.com/Project"]
  query       = "state:ACTIVE"
}