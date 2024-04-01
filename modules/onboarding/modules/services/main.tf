# modules/onboarding/modules/services/main.tf

# Enable the Service Usage API
resource "google_project_service" "serviceusage_api" {
  project                    = var.project_id
  service                    = "serviceusage.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
}

# Enable the Workflows API
resource "google_project_service" "workflows_api" {
  project                    = var.project_id
  service                    = "workflows.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = false
  depends_on                 = [google_project_service.serviceusage_api]
}

# Enable the required APIs specified in var.required_apis
resource "google_project_service" "required_apis" {
  for_each                   = toset(var.required_apis)
  project                    = var.project_id
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
  depends_on                 = [google_project_service.workflows_api]
}