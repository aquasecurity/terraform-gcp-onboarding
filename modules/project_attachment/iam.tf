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

# Generate a random integer for the Aqua service account ID only for organization same and single onboarding
resource "random_integer" "cspm_service_account_id" {
  count = var.type == "organization" ? 0 : 1
  min   = 1
  max   = 999
}

# Create a service account for CSPM only for single onboarding
#trivy:ignore:AVD-GCP-0011
resource "google_service_account" "cspm_service_account" {
  count        = var.type == "organization" ? 0 : 1
  account_id   = "aqua-${random_integer.cspm_service_account_id[0].result}"
  display_name = "aqua-${random_integer.cspm_service_account_id[0].result}"
  description  = "Aqua API Access"
  project      = var.project_id
}

# Bind the Aqua service account to the CSPM role
resource "google_project_iam_member" "project_iam_member_cspm_role" {
  count   = var.type == "single" ? 1 : 0
  project = var.project_id
  role    = google_project_iam_custom_role.cspm_role[0].id
  member  = "serviceAccount:${google_service_account.cspm_service_account[0].email}"
}

# Generate a service account key for the CSPM service account
resource "google_service_account_key" "cspm_service_account_key" {
  count              = var.type == "organization" ? 0 : 1
  service_account_id = google_service_account.cspm_service_account[0].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}