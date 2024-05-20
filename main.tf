# main.tf

module "onboarding" {
  source = "./modules/onboarding"
  providers = {
    google.onboarding = google.onboarding
  }
  enabled                     = var.type == "single" || var.type == "organization" ? true : false
  dedicated_project           = var.dedicated_project
  type                        = var.type
  aqua_volscan_api_url        = var.aqua_volscan_api_url
  aqua_tenant_id              = var.aqua_tenant_id
  aqua_aws_account_id         = var.aqua_aws_account_id
  org_id                      = local.org_id
  project_id                  = var.project_id
  project_number              = local.project_number
  region                      = var.region
  create_network              = var.create_network
  aqua_volscan_api_token      = var.aqua_volscan_api_token
  aqua_bucket_name            = var.aqua_bucket_name
  service_account_name        = local.service_account_name
  create_role_name            = var.create_role_name
  delete_role_name            = var.delete_role_name
  cspm_role_name              = var.cspm_role_name
  identity_pool_name          = local.identity_pool_name
  identity_pool_provider_name = local.identity_pool_provider_name
  firewall_name               = local.firewall_name
  network_name                = local.network_name
  topic_name                  = local.topic_name
  sink_name                   = local.sink_name
  workflow_name               = local.workflow_name
  trigger_name                = local.trigger_name
}