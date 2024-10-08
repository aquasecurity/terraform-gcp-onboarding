# modules/project_attachment/data.tf

# Retrieve the YAML file containing the Aqua CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  count = var.type == "single" ? 1 : 0
  url   = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}

# Retrieve the CSPM service account information if create service account toggle is disabled
data "google_service_account" "cspm_service_account" {
  count      = var.type == "organization" && !var.create_service_account ? 1 : 0
  account_id = local.cspm_service_account_name
  project    = var.onboarding_project_id
}