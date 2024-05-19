# modules/onboarding/modules/iam/outputs.tf

output "service_account_name" {
  value       = google_service_account.service_account.name
  description = "The name of the created Google Service Account"
}

output "service_account_id" {
  value       = google_service_account.service_account.id
  description = "The ID of the created Google Service Account"
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "The email address of the created Google Service Account"
}

output "workload_identity_pool_id" {
  value       = google_iam_workload_identity_pool.workload_identity_pool.workload_identity_pool_id
  description = "The ID of the created Workload Identity Pool"
}

output "workload_identity_pool_provider_id" {
  value       = google_iam_workload_identity_pool_provider.workload_identity_pool_provider.workload_identity_pool_provider_id
  description = "The ID of the created Workload Identity Pool Provider"
}

output "workload_identity_pool_provider_id_aws_account_id" {
  value       = google_iam_workload_identity_pool_provider.workload_identity_pool_provider.aws[0].account_id
  description = "The AWS account ID associated with the Workload Identity Pool Provider"
}

output "create_role_name" {
  value       = var.dedicated_project ? google_organization_iam_custom_role.iam_role_create[0].name : google_project_iam_custom_role.iam_role_create[0].name
  description = "The name of the custom IAM role created for the 'create' operation"
}

output "create_role_id" {
  value       = local.create_role_id
  description = "The ID of the custom IAM role created for the 'create' operation"
}

output "create_role_permissions" {
  value       = var.dedicated_project ? google_organization_iam_custom_role.iam_role_create[0].permissions : google_project_iam_custom_role.iam_role_create[0].permissions
  description = "The permissions associated with the custom IAM role created for the 'create' operation"
}

output "delete_role_name" {
  value       = var.dedicated_project ? google_organization_iam_custom_role.iam_role_delete[0].name : google_project_iam_custom_role.iam_role_delete[0].name
  description = "The name of the custom IAM role created for the 'delete' operation"
}

output "delete_role_id" {
  value       = var.dedicated_project ? google_organization_iam_custom_role.iam_role_delete[0].role_id : google_project_iam_custom_role.iam_role_delete[0].role_id
  description = "The ID of the custom IAM role created for the 'delete' operation"
}

output "delete_role_permissions" {
  value       = var.dedicated_project ? google_organization_iam_custom_role.iam_role_delete[0].permissions : google_project_iam_custom_role.iam_role_delete[0].permissions
  description = "The permissions associated with the custom IAM role created for the 'delete' operation"
}

output "cspm_role_name" {
  value       = var.type == "organization" ? var.cspm_role_name : null
  description = "The name of the custom IAM role created for CSPM"
}

output "cspm_role_id" {
  value       = local.cspm_role_id
  description = "The ID of the custom IAM role created for CSPM"
}

output "cspm_role_permissions" {
  value       = var.type == "organization" ? local.cspm_role_permissions : null
  description = "The permissions associated with the custom IAM role created for CSPM"
}

output "cspm_service_account_name" {
  value       = var.type == "organization" && var.dedicated_project ? google_service_account.cspm_service_account[0].name : null
  description = "The name of the created Google Service Account for CSPM"
}

output "cspm_service_account_id" {
  value       = var.type == "organization" && var.dedicated_project ? google_service_account.cspm_service_account[0].id : null
  description = "The ID of the created Google Service Account for CSPM"
}

output "cspm_service_account_email" {
  value       = var.type == "organization" && var.dedicated_project ? google_service_account.cspm_service_account[0].email : null
  description = "The email of the created Google Service Account for CSPM"
}

output "cspm_service_account_key" {
  value       = var.type == "organization" && var.dedicated_project ? google_service_account_key.cspm_service_account_key[0].private_key : null
  description = "The key of the created Google Service Account for CSPM"
  sensitive   = true
}