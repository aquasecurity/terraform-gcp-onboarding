
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = true
  type                   = "single"
  org_name               = "<org_name>"
  aqua_tenant_id         = "<tenant_id>"
  project_id             = "<project_id>"
  aqua_aws_account_id    = "123456789101"
  aqua_bucket_name       = "<aqua_bucket_name>"
  aqua_configuration_id  = "<aqua_configuration_id>"
  aqua_cspm_group_id     = 123456
  aqua_custom_labels     = {}
  aqua_api_key           = "<aqua_api_key>"
  aqua_api_secret        = "<aqua_api_secret>"
  aqua_autoconnect_url   = "https://<aqua_autoconnect_url>.com"
  aqua_volscan_api_token = "<aqua_volscan_api_token>"
  aqua_volscan_api_url   = "https://<aqua_volscan_api_url>.com"
  dedicated_project_id   = "aqua-agentless-${local.aqua_tenant_id}-${local.org_hash}"
  labels                 = merge(local.aqua_custom_labels, { "aqua-agentless-scanner" = "true" })
  org_hash               = substr(sha1(local.org_name), 0, 6)
}

################################

# Defining the root google provider
provider "google" {
  project        = local.project_id
  region         = local.region
  default_labels = local.labels
}

# Creating a dedicated project
module "aqua_gcp_dedicated_project" {
  source          = "../../modules/dedicated_project"
  org_name        = local.org_name
  project_id      = local.dedicated_project_id
  root_project_id = local.project_id
  labels          = local.labels
}

################################

# Defining the dedicated google provider
provider "google" {
  alias          = "dedicated"
  project        = module.aqua_gcp_dedicated_project.project_id
  region         = local.region
  default_labels = local.labels
}

# Creating onboarding resources on the dedicated project
module "aqua_gcp_onboarding" {
  source = "../../"
  providers = {
    google.onboarding = google.dedicated
  }
  type                   = local.type
  project_id             = module.aqua_gcp_dedicated_project.project_id
  region                 = local.region
  org_name               = local.org_name
  aqua_tenant_id         = local.aqua_tenant_id
  aqua_aws_account_id    = local.aqua_aws_account_id
  aqua_bucket_name       = local.aqua_bucket_name
  aqua_custom_labels     = local.aqua_custom_labels
  aqua_volscan_api_token = local.aqua_volscan_api_token
  aqua_volscan_api_url   = local.aqua_volscan_api_url
  create_network         = false
  depends_on             = [module.aqua_gcp_dedicated_project]
}

################################

## Onboarding an project and attaching it to the dedicated project
module "aqua_gcp_project_attachment" {
  source = "../../modules/project_attachment"
  providers = {
    google = google
  }
  aqua_api_key                                  = local.aqua_api_key
  aqua_api_secret                               = local.aqua_api_secret
  aqua_autoconnect_url                          = local.aqua_autoconnect_url
  aqua_bucket_name                              = local.aqua_bucket_name
  aqua_configuration_id                         = local.aqua_configuration_id
  aqua_cspm_group_id                            = local.aqua_cspm_group_id
  org_name                                      = local.org_name
  project_id                                    = local.project_id
  dedicated_project                             = local.dedicated
  labels                                        = local.aqua_custom_labels
  create_role_id                                = module.aqua_gcp_onboarding.create_role_id
  onboarding_service_account_email              = module.aqua_gcp_onboarding.service_account_email
  onboarding_workload_identity_pool_id          = module.aqua_gcp_onboarding.workload_identity_pool_id
  onboarding_workload_identity_pool_provider_id = module.aqua_gcp_onboarding.workload_identity_pool_provider_id
  onboarding_project_number                     = module.aqua_gcp_onboarding.project_number
  depends_on                                    = [module.aqua_gcp_onboarding]
}

output "onboarding_status" {
  value = module.aqua_gcp_project_attachment.onboarding_status
}