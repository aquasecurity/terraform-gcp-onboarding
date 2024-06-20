# modules/cspm_iam/data.tf

# Retrieve the YAML file containing the Aqua CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}

# Retrieve the CSPM service account information if create service account toggle is disabled
data "google_service_account" "cspm_service_account" {
  count      = var.create_service_account ? 0 : 1
  account_id = local.cspm_service_account_name
  project    = var.project_id
}