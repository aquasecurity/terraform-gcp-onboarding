# modules/project_attachment/outputs.tf

# Onboarding API call output
output "onboarding_status" {
  value = data.external.gcp_onboarding.result.status
}
