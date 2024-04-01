# modules/onboarding/modules/services/outputs.tf

output "project_api_services" {
  description = "Map of enabled API services in the project"
  value = {
    for service_key, service_info in google_project_service.required_apis :
    service_key => service_info.service
  }
}