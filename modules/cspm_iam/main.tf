# modules/cspm_iam/main.tf

# Create a custom IAM role for Aqua CSPM for same organization onboarding
resource "google_organization_iam_custom_role" "cspm_role" {
  role_id     = var.cspm_role_name
  org_id      = var.org_id
  title       = var.cspm_role_name
  description = var.cspm_role_name
  permissions = tolist(local.cspm_role_permissions)
}

# Create a service account for Aqua CSPM for same organization onboarding
#trivy:ignore:AVD-GCP-0011
resource "google_service_account" "aqua_cspm_service_account" {
  count        = var.create_service_account ? 1 : 0
  account_id   = local.cspm_service_account_name
  display_name = local.cspm_service_account_name
  description  = "Aqua API Access"
  project      = var.project_id
}

# Generate a service account key for the CSPM service account
resource "google_service_account_key" "cspm_service_account_key" {
  count              = var.create_service_account ? 1 : 0
  service_account_id = google_service_account.aqua_cspm_service_account[0].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Bind the IAM role to the service account at the organization level
resource "google_organization_iam_binding" "organization_iam_binding_cspm_role" {
  org_id = var.org_id
  role   = google_organization_iam_custom_role.cspm_role.id
  members = [
    "serviceAccount:${var.create_service_account ? google_service_account.aqua_cspm_service_account[0].email : data.google_service_account.cspm_service_account[0].email}",
  ]
}
