
# Defining local variables
locals {
  region                 = "us-central1"
  dedicated              = false
  type                   = "organization"
  org_name               = "my-org-name"
  aqua_tenant_id         = "12345"
  aqua_aws_account_id    = "123456789101"
  aqua_bucket_name       = "generic-bucket-name"
  aqua_configuration_id  = "234e3cea-d84a-4b9e-bb36-92518e6a5772"
  aqua_cspm_group_id     = 123456
  aqua_custom_labels     = { label = "true" }
  aqua_api_key           = "<REPLACE_ME>"
  aqua_api_secret        = "<REPLACE_ME>"
  aqua_autoconnect_url   = "https://example-aqua-autoconnect-url.com"
  aqua_volscan_api_token = "<REPLACE_ME>"
  aqua_volscan_api_url   = "https://example-aqua-volscan-api-url.com"
  cspm_project_id        = "" # project id where CSPM iam resources will be provisioned. If not set, it will be set by default to the first project in the organization
  labels                 = merge(local.aqua_custom_labels, { "aqua-agentless-scanner" = "true" })
  projects_list          = ["my-project-id-1", "my-project-id-2"]
}

################################

# Defining the root google provider
provider "google" {
  region         = local.region
  default_labels = local.labels
}

# Getting google organization ID
data "google_organization" "org" {
  domain = local.org_name
}

################################

# Creating CSPM IAM resources
module "aqua_gcp_cspm_iam" {
  source = "../../modules/cspm_iam"
  providers = {
    google = google
  }
  project_id       = local.cspm_project_id == "" ? local.projects_list[0] : local.cspm_project_id
  aqua_bucket_name = local.aqua_bucket_name
  aqua_tenant_id   = local.aqua_tenant_id
  org_id           = data.google_organization.org.org_id
}

################################

# Iterating over all project and creating discovery and scanning resources each project
module "aqua_gcp_onboarding" {
  source = "../../"
  providers = {
    google.onboarding = google
  }
  for_each               = toset(local.projects_list)
  type                   = local.type
  project_id             = each.value
  dedicated_project      = local.dedicated
  region                 = local.region
  org_name               = local.org_name
  aqua_tenant_id         = local.aqua_tenant_id
  aqua_aws_account_id    = local.aqua_aws_account_id
  aqua_bucket_name       = local.aqua_bucket_name
  aqua_volscan_api_token = local.aqua_volscan_api_token
  aqua_volscan_api_url   = local.aqua_volscan_api_url
}

################################

## Iterating over all project and creating attachment resources
module "aqua_gcp_projects_attachment" {
  source = "../../modules/project_attachment"
  providers = {
    google = google
  }
  for_each                                      = toset(local.projects_list)
  aqua_api_key                                  = local.aqua_api_key
  type                                          = local.type
  aqua_api_secret                               = local.aqua_api_secret
  aqua_autoconnect_url                          = local.aqua_autoconnect_url
  aqua_bucket_name                              = local.aqua_bucket_name
  aqua_configuration_id                         = local.aqua_configuration_id
  aqua_cspm_group_id                            = local.aqua_cspm_group_id
  org_name                                      = local.org_name
  project_id                                    = each.value
  dedicated_project                             = local.dedicated
  labels                                        = local.aqua_custom_labels
  onboarding_create_role_id                     = module.aqua_gcp_onboarding[each.value].create_role_id                     # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.aqua_gcp_onboarding[each.value].service_account_email              # Referencing outputs from the onboarding module
  onboarding_cspm_service_account_key           = module.aqua_gcp_cspm_iam.cspm_service_account_key                         # Referencing outputs from the cspm_iam module
  onboarding_workload_identity_pool_id          = module.aqua_gcp_onboarding[each.value].workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.aqua_gcp_onboarding[each.value].workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.aqua_gcp_onboarding[each.value].project_number                     # Referencing outputs from the onboarding module
  depends_on                                    = [module.aqua_gcp_onboarding]
}

output "onboarding_status" {
  value = {
    for project_id, attachment_instance in module.aqua_gcp_projects_attachment :
    project_id => attachment_instance.onboarding_status
  }
}