## modules/onboarding/modules/iam/data.tf

# Retrieve the YAML file containing the Aqua create role definition
data "http" "autoconnect_create_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_agentless_role.yaml"
}

# Retrieve the YAML file containing the Aqua delete role definition
data "http" "autoconnect_delete_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_agentless_delete_role.yaml"
}

# Retrieve the YAML file containing the Aqua CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}

# Retrieve the service account information if create service account toggle is disabled
data "google_service_account" "service_account" {
  count      = var.create_service_account ? 0 : 1
  account_id = var.service_account_name
  project    = var.project_id
}

# Retrieve the CSPM service account information in case that onboarding type is organization dedicated and create service account toggle is disabled
data "google_service_account" "cspm_service_account" {
  count      = var.type == "organization" && var.dedicated_project && !var.create_service_account ? 1 : 0
  account_id = var.cspm_service_account_name
  project    = var.project_id
}