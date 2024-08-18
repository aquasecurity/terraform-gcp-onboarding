# outputs.tf

# Global outputs
output "org_name" {
  value       = var.show_outputs ? var.org_name : null
  description = "Google Cloud Organization name"
}

output "org_id" {
  value       = var.show_outputs ? local.org_id : null
  description = "Google Cloud Organization ID"
}

output "project_number" {
  value       = local.project_number
  description = "Google Cloud Project number"
}

output "project_id" {
  value       = var.project_id
  description = "Google Cloud Project ID"
}

output "region" {
  value       = var.show_outputs ? var.region : null
  description = "Google Cloud Region"
}

output "custom_firewall_name" {
  value       = var.firewall_name
  description = "Firewall Name. This will be the value of var.firewall_name if set; otherwise, it will be ''."
}

# Onboarding module outputs
output "eventarc_trigger_name" {
  value       = var.show_outputs ? module.onboarding.eventarc_trigger_name : null
  description = "Eventarc trigger name"
}

output "eventarc_trigger_destination_workflow" {
  value       = var.show_outputs ? module.onboarding.eventarc_trigger_destination_workflow : null
  description = "Destination workflow for the eventarc trigger"
}

output "service_account_name" {
  value       = var.show_outputs ? module.onboarding.service_account_name : null
  description = "Service account name"
}

output "service_account_id" {
  value       = var.show_outputs ? module.onboarding.service_account_id : null
  description = "Service account ID"
}

output "service_account_email" {
  value       = module.onboarding.service_account_email
  description = "Service account email"
}

output "workload_identity_pool_id" {
  value       = module.onboarding.workload_identity_pool_id
  description = "Workload identity pool ID"
}

output "workload_identity_pool_provider_id" {
  value       = module.onboarding.workload_identity_pool_provider_id
  description = "Workload identity pool provider ID"
}

output "workload_identity_pool_provider_id_aws_account_id" {
  value       = var.show_outputs ? module.onboarding.workload_identity_pool_provider_id_aws_account_id : null
  description = "Workload identity pool provider AWS account ID"
}

# Role-related outputs
output "create_role_name" {
  value       = module.onboarding.create_role_name
  description = "Create role name"
}

output "create_role_id" {
  value       = module.onboarding.create_role_id
  description = "Create role ID"
}

output "create_role_permissions" {
  value       = var.show_outputs ? module.onboarding.create_role_permissions : null
  description = "Permissions of the created role"
}

output "delete_role_name" {
  value       = var.show_outputs ? module.onboarding.delete_role_name : null
  description = "Delete role name"
}

output "delete_role_permissions" {
  value       = var.show_outputs ? module.onboarding.delete_role_permissions : null
  description = "Permissions of the deleted role"
}

output "cspm_role_id" {
  value       = module.onboarding.cspm_role_id
  description = "CSPM role ID"
}

output "cspm_role_name" {
  value       = module.onboarding.cspm_role_name
  description = "CSPM role name"
}

output "cspm_role_permissions" {
  value       = var.show_outputs ? module.onboarding.cspm_role_permissions : null
  description = "Permissions of the CSPM role"
}

output "cspm_service_account_name" {
  value       = var.show_outputs ? module.onboarding.cspm_service_account_name : null
  description = "CSPM Service account name"
}

output "cspm_service_account_id" {
  value       = var.show_outputs ? module.onboarding.cspm_service_account_id : null
  description = "CSPM Service account ID"
}

output "cspm_service_account_email" {
  value       = module.onboarding.cspm_service_account_email
  description = "CSPM Service account email"
}

output "cspm_service_account_key" {
  value       = module.onboarding.cspm_service_account_key
  description = "CSPM Service account key"
  sensitive   = true
}

# Network-related outputs
output "network_name" {
  value       = var.show_outputs ? module.onboarding.network_name : null
  description = "Network name"
}

output "firewall_name" {
  value       = var.show_outputs ? module.onboarding.firewall_name : null
  description = "Firewall name"
}

# Pub/Sub and Logging outputs
output "pubsub_topic_name" {
  value       = var.show_outputs ? module.onboarding.pubsub_topic_name : null
  description = "Pubsub topic name"
}

output "sink_name" {
  value       = var.show_outputs ? module.onboarding.sink_name : null
  description = "Sink name"
}

# Project-related outputs
output "project_api_services" {
  value       = var.show_outputs ? module.onboarding.project_api_services : null
  description = "API services enabled in the project"
}

# Workflow output
output "workflow_name" {
  value       = var.show_outputs ? module.onboarding.workflow_name : null
  description = "Workflow name"
}