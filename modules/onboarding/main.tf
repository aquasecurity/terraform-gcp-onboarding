# modules/onboarding/main.tf

module "services" {
  source = "./modules/services"
  count  = var.enabled ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  project_id    = var.project_id
  required_apis = local.required_apis
}

module "iam" {
  source = "./modules/iam"
  count  = var.enabled ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  project_id                  = var.project_id
  project_number              = var.project_number
  org_id                      = var.org_id
  type                        = var.type
  create_service_account      = var.create_service_account
  cspm_service_account_name   = var.cspm_service_account_name
  service_account_name        = var.service_account_name
  identity_pool_name          = var.identity_pool_name
  identity_pool_provider_name = var.identity_pool_provider_name
  create_role_name            = var.create_role_name
  delete_role_name            = var.delete_role_name
  cspm_role_name              = var.cspm_role_name
  aqua_aws_account_id         = var.aqua_aws_account_id
  aqua_bucket_name            = var.aqua_bucket_name
  dedicated_project           = var.dedicated_project
  depends_on                  = [module.services]
}

module "pubsub" {
  source = "./modules/pubsub"
  count  = var.enabled ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  project_id            = var.project_id
  topic_name            = var.topic_name
  sink_name             = var.sink_name
  service_account_email = module.iam[0].service_account_email
  depends_on            = [module.iam]
}

module "workflow" {
  source = "./modules/workflow"
  count  = var.enabled ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  project_id             = var.project_id
  workflow_name          = var.workflow_name
  region                 = var.region
  service_account_email  = module.iam[0].service_account_email
  aqua_volscan_api_url   = var.aqua_volscan_api_url
  aqua_volscan_api_token = var.aqua_volscan_api_token
  depends_on             = [module.pubsub]
}

module "eventarc" {
  source = "./modules/eventarc"
  count  = var.enabled ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  project_id            = var.project_id
  region                = var.region
  service_account_email = module.iam[0].service_account_email
  topic_name            = var.topic_name
  trigger_name          = var.trigger_name
  workflow_name         = var.workflow_name
  depends_on            = [module.workflow]
}

module "network" {
  source = "./modules/network"
  count  = var.enabled && var.create_network ? 1 : 0
  providers = {
    google.onboarding = google.onboarding
  }
  network_name  = var.network_name
  firewall_name = var.firewall_name
  project_id    = var.project_id
  depends_on    = [module.eventarc]
}


