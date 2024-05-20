# modules/onboarding/modules/iam/main.tf

# Create a Workload Identity Pool
resource "google_iam_workload_identity_pool" "workload_identity_pool" {
  display_name              = "Aqua agentless pool"
  description               = "Aqua agentless pool"
  project                   = var.project_id
  workload_identity_pool_id = var.identity_pool_name
}

# Create a Workload Identity Pool Provider for AWS
#trivy:ignore:AVD-GCP-0068
resource "google_iam_workload_identity_pool_provider" "workload_identity_pool_provider" {
  #checkov:skip=CKV_GCP_118:Ensure IAM workload identity pool provider is restricted
  display_name = "identity pool provider"
  project      = var.project_id
  attribute_mapping = {
    "google.subject" = "'assertion.sub'"
  }
  aws {
    account_id = var.aqua_aws_account_id
  }
  workload_identity_pool_id          = google_iam_workload_identity_pool.workload_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.identity_pool_provider_name
}

# Create a custom IAM role for creating resources for same project onboarding
resource "google_project_iam_custom_role" "iam_role_create" {
  count       = var.dedicated_project ? 0 : 1
  role_id     = var.create_role_name
  title       = var.create_role_name
  description = var.create_role_name
  project     = var.project_id
  permissions = tolist(local.create_role_permissions)
  depends_on  = [google_iam_workload_identity_pool_provider.workload_identity_pool_provider]
}

# Create a custom IAM role for deleting resources for same project onboarding
resource "google_project_iam_custom_role" "iam_role_delete" {
  count       = var.dedicated_project ? 0 : 1
  role_id     = var.delete_role_name
  title       = var.delete_role_name
  project     = var.project_id
  description = var.delete_role_name
  permissions = tolist(local.delete_role_permissions)
  depends_on  = [google_organization_iam_custom_role.iam_role_create]
}

# Create a custom IAM role for creating resources for dedicated project onboarding
resource "google_organization_iam_custom_role" "iam_role_create" {
  count       = var.dedicated_project ? 1 : 0
  role_id     = var.create_role_name
  org_id      = var.org_id
  title       = var.create_role_name
  description = var.create_role_name
  permissions = tolist(local.create_role_permissions)
  depends_on  = [google_iam_workload_identity_pool_provider.workload_identity_pool_provider]
}

# Create a custom IAM role for deleting resources for dedicated project onboarding
resource "google_organization_iam_custom_role" "iam_role_delete" {
  count       = var.dedicated_project ? 1 : 0
  role_id     = var.delete_role_name
  org_id      = var.org_id
  title       = var.delete_role_name
  description = var.delete_role_name
  permissions = tolist(local.delete_role_permissions)
  depends_on  = [google_organization_iam_custom_role.iam_role_create]
}

# Create a custom IAM role for Aqua CSPM for dedicated organization onboarding
resource "google_organization_iam_custom_role" "cspm_role" {
  count       = var.type == "organization" && var.dedicated_project ? 1 : 0
  role_id     = var.cspm_role_name
  org_id      = var.org_id
  title       = var.cspm_role_name
  description = var.cspm_role_name
  permissions = tolist(local.cspm_role_permissions)
}

# Create a service account
resource "google_service_account" "service_account" {
  account_id = var.service_account_name
  project    = var.project_id
  depends_on = [google_organization_iam_custom_role.iam_role_delete]
}

# Create a service account for Aqua CSPM for dedicated organization onboarding
#trivy:ignore:AVD-GCP-0011
resource "google_service_account" "cspm_service_account" {
  count        = var.type == "organization" && var.dedicated_project ? 1 : 0
  account_id   = "aqua-cspm-scanner-${var.aqua_tenant_id}"
  display_name = "aqua-cspm-scanner-${var.aqua_tenant_id}"
  description  = "Aqua API Access"
  project      = var.project_id
}

# Generate a service account key for the CSPM service account
resource "google_service_account_key" "cspm_service_account_key" {
  count              = var.type == "organization" && var.dedicated_project ? 1 : 0
  service_account_id = google_service_account.cspm_service_account[0].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_organization_iam_binding" "organization_iam_binding_cspm_role" {
  count  = var.type == "organization" && var.dedicated_project ? 1 : 0
  org_id = var.org_id
  role   = local.cspm_role_id

  members = [
    "serviceAccount:${google_service_account.cspm_service_account[0].email}",
  ]
}

# Bind the service account to the Pub/Sub Publisher role
resource "google_project_iam_binding" "project_iam_binding_pubsub" {
  project = var.project_id
  role    = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Workflows Admin role
resource "google_project_iam_binding" "project_iam_binding_workflows" {
  project = var.project_id
  role    = "roles/workflows.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Eventarc Admin role
resource "google_project_iam_binding" "project_iam_binding_eventarc" {
  project = var.project_id
  role    = "roles/eventarc.admin"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Eventarc Service agent
#trivy:ignore:AVD-GCP-0011
resource "google_project_iam_binding" "project_iam_binding_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Container Viewer role
resource "google_project_iam_binding" "project_iam_binding_container" {
  project = var.project_id
  role    = "roles/container.viewer"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Workload Identity User role
resource "google_service_account_iam_binding" "service_account_iam_binding_principal_set" {
  service_account_id = google_service_account.service_account.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.workload_identity_pool.workload_identity_pool_id}/*",
  ]
}

# Bind the service account to the custom create role
resource "google_project_iam_binding" "project_iam_binding_create_role" {
  project = var.project_id
  role    = local.create_role_id
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the custom delete role with a condition
resource "google_project_iam_binding" "project_iam_binding_delete_role" {
  project = var.project_id
  role    = local.delete_role_id
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
  condition {
    title       = "Aqua Resource Delete Condition"
    description = "Condition for Aqua delete role to delete aqua resources only"
    expression  = "resource.type == \"compute.googleapis.com/Instance\" || resource.type == \"compute.googleapis.com/Disk\" && resource.name.startsWith(\"projects/${var.project_id}\") && resource.name.endsWith(\"-aas\")"
  }
}