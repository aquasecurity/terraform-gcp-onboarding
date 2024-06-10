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
  value       = var.create_service_account ? google_service_account.aqua_cspm_service_account[0].name : data.google_service_account.cspm_service_account[0].name
  description = "The name of the created or fetched Google Service Account for CSPM"
}

output "cspm_service_account_id" {
  value       = var.create_service_account ? google_service_account.aqua_cspm_service_account[0].id : data.google_service_account.cspm_service_account[0].id
  description = "The ID of the created or fetched Google Service Account for CSPM"
}

output "cspm_service_account_email" {
  value       = var.create_service_account ? google_service_account.aqua_cspm_service_account[0].email : data.google_service_account.cspm_service_account[0].email
  description = "The email of the created or fetched Google Service Account for CSPM"
}

output "cspm_service_account_key" {
  value       = var.create_service_account ? google_service_account_key.cspm_service_account_key[0].private_key : null
  description = "The key of the created Google Service Account for CSPM"
  sensitive   = true
}