# modules/project_attachment/services.tf

# Enable Google Cloud Services
resource "google_project_service" "project_api_services" {
  for_each                   = var.dedicated_project ? { for service in local.api_services : service => service } : {}
  service                    = each.value
  project                    = var.project_id
  disable_on_destroy         = false
  disable_dependent_services = false
}
