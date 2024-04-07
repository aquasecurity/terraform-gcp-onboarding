# locals.tf

locals {
  # Organization-related locals
  org_id = var.dedicated_project ? data.google_organization.organization.org_id : "" # Using empty string because same-project does not use org_id

  # Project-related locals
  project_number = data.google_project.project.number
  project_id     = data.google_project.project.project_id

  # Label-related locals
  labels = merge(var.aqua_custom_labels, { "aqua-agentless-scanner" = "true" })

  # Resource naming locals
  identity_pool_name          = var.identity_pool_name != null ? var.identity_pool_name : "aqua-agentless-pool-${var.aqua_tenant_id}"
  identity_pool_provider_name = var.identity_pool_provider_name != null ? var.identity_pool_provider_name : "agentless-provider-${var.aqua_tenant_id}"
  service_account_name        = var.service_account_name != null ? var.service_account_name : "aqua-agentless-sa-${var.aqua_tenant_id}"
  firewall_name               = "${local.project_id}-rules-aqua-aas"
  network_name                = "${local.project_id}-network"
  topic_name                  = var.topic_name != null ? var.topic_name : "${local.project_id}-topic"
  sink_name                   = var.sink_name != null ? var.sink_name : "${local.project_id}-sink"
  workflow_name               = var.workflow_name != null ? var.workflow_name : "${local.project_id}-workflow"
  trigger_name                = var.trigger_name != null ? var.trigger_name : "${local.project_id}-trigger"
}