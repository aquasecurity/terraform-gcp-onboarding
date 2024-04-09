# modules/project_attachment/data.tf

# Retrieve the YAML file containing the Aqua CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}

# Retrieve information about the Google Cloud organization
data "google_organization" "organization" {
  count  = var.dedicated_project ? 1 : 0
  domain = var.org_name
}
