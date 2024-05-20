# modules/onboarding/outputs.tf

# Eventarc module outputs
output "eventarc_trigger_name" {
  value       = var.enabled ? module.eventarc[0].eventarc_trigger_name : null
  description = "The name of the Eventarc trigger created by the eventarc module"
}

output "eventarc_trigger_destination_workflow" {
  value       = var.enabled ? module.eventarc[0].eventarc_trigger_destination_workflow : null
  description = "The name of the Cloud Workflows workflow associated with the Eventarc trigger created by the eventarc module"
}

# IAM module outputs
output "service_account_name" {
  value       = var.enabled ? module.iam[0].service_account_name : null
  description = "The name of the service account created by the iam module"
}

output "service_account_id" {
  value       = var.enabled ? module.iam[0].service_account_id : null
  description = "The ID of the service account created by the iam module"
}

output "service_account_email" {
  value       = var.enabled ? module.iam[0].service_account_email : null
  description = "The email address of the service account created by the iam module"
}

output "workload_identity_pool_id" {
  value       = var.enabled ? module.iam[0].workload_identity_pool_id : null
  description = "The ID of the Workload Identity Pool created by the iam module"
}

output "workload_identity_pool_provider_id" {
  value       = var.enabled ? module.iam[0].workload_identity_pool_provider_id : null
  description = "The ID of the Workload Identity Pool Provider created by the iam module"
}

output "workload_identity_pool_provider_id_aws_account_id" {
  value       = var.enabled ? module.iam[0].workload_identity_pool_provider_id_aws_account_id : null
  description = "The AWS account ID associated with the Workload Identity Pool Provider created by the iam module"
}

output "create_role_name" {
  value       = var.enabled ? module.iam[0].delete_role_name : null
  description = "The name of the custom IAM role created for the 'create' operation by the iam module"
}

output "create_role_id" {
  value       = var.enabled ? module.iam[0].create_role_id : null
  description = "The ID of the custom IAM role created for the 'create' operation by the iam module"
}

output "create_role_permissions" {
  value       = var.enabled ? module.iam[0].create_role_permissions : null
  description = "The list of permissions associated with the custom IAM role created for the 'create' operation by the iam module"
}

output "delete_role_name" {
  value       = var.enabled ? module.iam[0].delete_role_name : null
  description = "The name of the custom IAM role created for the 'delete' operation by the iam module"
}

output "delete_role_id" {
  value       = var.enabled ? module.iam[0].delete_role_id : null
  description = "The ID of the custom IAM role created for the 'delete' operation by the iam module"
}

output "delete_role_permissions" {
  value       = var.enabled ? module.iam[0].delete_role_permissions : null
  description = "The list of permissions associated with the custom IAM role created for the 'delete' operation by the iam module"
}

output "cspm_role_name" {
  value       = var.enabled ? module.iam[0].cspm_role_name : null
  description = "The name of the custom IAM role created for cspm by the iam module"
}

output "cspm_role_id" {
  value       = var.enabled ? module.iam[0].cspm_role_id : null
  description = "The ID of the custom IAM role created for cspm by the iam module"
}

output "cspm_role_permissions" {
  value       = var.enabled ? module.iam[0].cspm_role_permissions : null
  description = "The list of permissions associated with the custom IAM role created for cspm by the iam module"
}

output "cspm_service_account_name" {
  value       = var.enabled ? module.iam[0].cspm_service_account_name : null
  description = "The name of the service account for CSPM created by the iam module"
}

output "cspm_service_account_id" {
  value       = var.enabled ? module.iam[0].cspm_service_account_id : null
  description = "The ID of the service account for CSPM created by the iam module"
}

output "cspm_service_account_email" {
  value       = var.enabled ? module.iam[0].cspm_service_account_email : null
  description = "The email address of the service account for CSPM created by the iam module"
}

output "cspm_service_account_key" {
  value       = var.enabled ? module.iam[0].cspm_service_account_key : null
  description = "The key of the service account for CSPM created by the iam module"
  sensitive   = true
}

# Network module outputs
output "network_name" {
  value       = var.enabled && var.create_network ? module.network[0].network_name : null
  description = "The name of the network created by the network module"
}

output "firewall_name" {
  value       = var.enabled && var.create_network ? module.network[0].firewall_name : null
  description = "The name of the firewall rule created by the network module"
}

# Pubsub module outputs
output "pubsub_topic_name" {
  value       = var.enabled ? module.pubsub[0].pubsub_topic_name : null
  description = "The name of the Cloud Pub/Sub topic created by the pubsub module"
}

output "sink_name" {
  value       = var.enabled ? module.pubsub[0].sink_name : null
  description = "The name of the logging sink created by the pubsub module"
}

# Services module outputs
output "project_api_services" {
  value       = var.enabled ? module.services[0].project_api_services : null
  description = "The list of Google Cloud API services enabled by the services module"
}

# Workflow module outputs
output "workflow_name" {
  value       = var.enabled ? module.workflow[0].workflow_name : null
  description = "The name of the Cloud Workflows workflow created by the workflow module"
}