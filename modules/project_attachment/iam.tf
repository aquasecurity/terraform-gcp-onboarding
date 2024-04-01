# modules/project_attachment/iam.tf

# Bind the Aqua service account to the custom create role
resource "google_project_iam_binding" "project_iam_binding_create_role" {
  project = var.project_id
  role    = "organizations/${local.org_id}/roles/${var.create_role_id}"
  members = [
    "serviceAccount:${var.onboarding_service_account_email}",
  ]
}

# Create a custom IAM role for Aqua CSPM
resource "google_project_iam_custom_role" "cspm_role" {
  role_id     = "AquaAutoConnectRole"
  title       = "AquaAutoConnectRole"
  description = "Aqua AutoConnect Role"
  permissions = tolist(local.cspm_role_permissions)
  project     = var.project_id
}

# Generate a random integer for the Aqua service account ID
resource "random_integer" "aqua_service_account_id" {
  min = 1
  max = 999
}

# Create a service account for Aqua
#trivy:ignore:AVD-GCP-0011
resource "google_service_account" "aqua_service_account" {
  account_id   = "aqua-${random_integer.aqua_service_account_id.result}"
  display_name = "Aqua-${random_integer.aqua_service_account_id.result}"
  description  = "Aqua API Access"
  project      = var.project_id
}

# Grant the service account access to the custom role
resource "google_project_iam_member" "service_account_role" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${google_project_iam_custom_role.cspm_role.role_id}"
  member  = "serviceAccount:${google_service_account.aqua_service_account.email}"
}

# Generate a service account key for the Aqua service account
resource "google_service_account_key" "aqua_service_account_key" {
  service_account_id = google_service_account.aqua_service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}