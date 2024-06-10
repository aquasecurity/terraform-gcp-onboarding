
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = true
  type                   = "single"
  org_name               = "my-org-name"
  aqua_tenant_id         = "12345"
  project_id             = "my-project-id"
  aqua_aws_account_id    = "123456789101"
  aqua_bucket_name       = "generic-bucket-name"
  aqua_configuration_id  = "234e3cea-d84a-4b9e-bb36-92518e6a5772"
  aqua_cspm_group_id     = 123456
  aqua_custom_labels     = { custom = "label" }
  aqua_api_key           = "<REPLACE_ME>"
  aqua_api_secret        = "<REPLACE_ME>"
  aqua_autoconnect_url   = "https://example-aqua-autoconnect-url.com"
  aqua_volscan_api_token = "<REPLACE_ME>"
  aqua_volscan_api_url   = "https://example-aqua-volscan-api-url.com"
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
  type            = local.type
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

# Creating discovery and scanning resources on the project
module "aqua_gcp_onboarding" {
  source = "../../"
  providers = {
    google.onboarding = google.dedicated
  }
  type                   = local.type
  project_id             = module.aqua_gcp_dedicated_project.project_id
  dedicated_project      = local.dedicated
  region                 = local.region
  org_name               = local.org_name
  aqua_tenant_id         = local.aqua_tenant_id
  aqua_aws_account_id    = local.aqua_aws_account_id
  aqua_bucket_name       = local.aqua_bucket_name
  aqua_volscan_api_token = local.aqua_volscan_api_token
  aqua_volscan_api_url   = local.aqua_volscan_api_url
  depends_on             = [module.aqua_gcp_dedicated_project]
}

################################

# Onboarding a project and attaching it to the dedicated project
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
  aqua_tenant_id                                = local.aqua_tenant_id
  type                                          = local.type
  org_name                                      = local.org_name
  project_id                                    = local.project_id
  dedicated_project                             = local.dedicated
  labels                                        = local.aqua_custom_labels
  onboarding_create_role_id                     = module.aqua_gcp_onboarding.create_role_id                     # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.aqua_gcp_onboarding.service_account_email              # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_id          = module.aqua_gcp_onboarding.workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.aqua_gcp_onboarding.workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.aqua_gcp_onboarding.project_number                     # Referencing outputs from the onboarding module
  onboarding_project_id                         = module.aqua_gcp_onboarding.project_id                         # Referencing outputs from the onboarding module
  depends_on                                    = [module.aqua_gcp_onboarding]
}

output "onboarding_status" {
  value = module.aqua_gcp_project_attachment.onboarding_status
}