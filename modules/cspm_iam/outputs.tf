# modules/cspm_iam/outputs.tf

output "cspm_role_name" {
  value       = var.cspm_role_name
  description = "The name of the custom IAM role created for CSPM"
}

output "cspm_role_id" {
  value       = local.cspm_role_id
  description = "The ID of the custom IAM role created for CSPM"
}

output "cspm_role_permissions" {
  value       = local.cspm_role_permissions
  description = "The permissions associated with the custom IAM role created for CSPM"
}

output "cspm_service_account_name" {
  value       = google_service_account.aqua_cspm_service_account.name
  description = "The name of the created Google Service Account for CSPM"
}

output "cspm_service_account_id" {
  value       = google_service_account.aqua_cspm_service_account.id
  description = "The ID of the created Google Service Account for CSPM"
}

output "cspm_service_account_email" {
  value       = google_service_account.aqua_cspm_service_account.email
  description = "The email of the created Google Service Account for CSPM"
}

output "cspm_service_account_key" {
  value       = google_service_account_key.cspm_service_account_key.private_key
  description = "The key of the created Google Service Account for CSPM"
  sensitive   = true
}