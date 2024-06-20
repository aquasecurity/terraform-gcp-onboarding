# modules/project_attachment/iam.tf

# Bind the Aqua service account to the CSPM role
resource "google_project_iam_member" "project_iam_member_create_role" {
  project = var.project_id
  role    = var.onboarding_create_role_id
  member  = "serviceAccount:${var.onboarding_service_account_email}"
}

# Create a custom IAM role for Aqua CSPM
resource "google_project_iam_custom_role" "cspm_role" {
  count       = var.type == "single" ? 1 : 0
  role_id     = var.cspm_role_name
  title       = var.cspm_role_name
  description = "Aqua AutoConnect Role"
  permissions = tolist(local.cspm_role_permissions)
  project     = var.project_id
}

# Create CSPM service account in case that onboarding type is single and create service account toggle is enabled
#trivy:ignore:AVD-GCP-0011
resource "google_service_account" "cspm_service_account" {
  count        = var.type == "single" && var.create_service_account ? 1 : 0
  account_id   = local.cspm_service_account_name
  display_name = local.cspm_service_account_name
  description  = "Aqua API Access"
  project      = var.project_id
}

# Bind the CSPM service account to the CSPM role in case that onboarding type is single
resource "google_project_iam_member" "project_iam_member_cspm_role" {
  count   = var.type == "single" ? 1 : 0
  project = var.project_id
  role    = google_project_iam_custom_role.cspm_role[0].id
  member  = "serviceAccount:${local.cspm_service_account_email}"
}

# Generate a service account key for the CSPM service account in case that onboarding type is single and create service account toggle is enabled
resource "google_service_account_key" "cspm_service_account_key" {
  count              = var.type == "single" && var.create_service_account ? 1 : 0
  service_account_id = google_service_account.cspm_service_account[0].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}