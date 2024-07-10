# modules/project_attachment/outputs.tf

# Onboarding API call output
output "onboarding_status" {
  description = "Onboarding API Status Result"
  value       = data.external.gcp_onboarding.result.status
}
