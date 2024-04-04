![Aquasecurity logo](https://avatars3.githubusercontent.com/u/12783832?s=200&v=4)

# Terraform-gcp-onboarding

![Trivy](https://github.com/aquasecurity/terraform-gcp-onboarding/actions/workflows/trivy-scan.yaml/badge.svg)
[![Release](https://img.shields.io/github/v/release/aquasecurity/terraform-gcp-onboarding)](https://github.com/aquasecurity/terraform-gcp-onboarding/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This Terraform module provides an easy way
to configure Aqua Security’s CSPM and agentless solutions on Google Cloud Platform (GCP).

It creates the necessary resources, such as service accounts, roles, and permissions,
to enable seamless integration with Aqua’s platform.

---

## Table of Contents

- [Pre-requisites](#Pre-requisites)
- [Usage](#usage)
- [Examples](#examples)
- [Using Existing Network](#using-existing-network-and-firewall)
- [Using Dedicated Project](#using-an-existing-dedicated-project)

## Pre-requisites

Before using this module, ensure that you have the following:

- Terraform version `1.6.4` or later.
- `gcloud` CLI installed and configured.
- `Python` 3+ installed.
- Aqua Security account API credentials.

## Usage
1. Leverage the Aqua platform to generate the local variables required by the module.
2. Important: Replace `<aqua_api_key>` and `<aqua_api_secret>` with your generated API credentials.
2. Run `terraform init` to initialize the module.
3. Run `terraform apply` to create the resources.

## Examples

Here's an example of how to use this module while using a dedicated project:

```hcl

# Defining local variables
locals {
  region                 = "us-central1"               # Google Cloud region to use
  dedicated              = true                        # Whether to create a dedicated project for Aqua resources
  type                   = "single"                    # Type of deployment (single project or organization)
  org_name               = "<org_name>"                # Google Cloud Organization name
  tenant_id              = "<tenant_id>"               # Aqua tenant ID
  project_id             = "<project_id>"              # Google Cloud project ID (existing project to be onboarded)
  aqua_aws_account_id    = "<aqua_aws_account_id>"     # Aqua AWS account ID
  aqua_bucket_name       = "<aqua_bucket_name>"        # Aqua bucket name
  aqua_configuration_id  = "<aqua_configuration_id>"   # Aqua configuration ID
  aqua_cspm_group_id     = 123456                      # Aqua CSPM group ID
  aqua_custom_labels     = { label = "true" }          # Additional custom labels to apply to Aqua resources
  aqua_api_key           = "<aqua_api_key>"            # Replace with generated aqua API key
  aqua_api_secret        = "<aqua_api_secret>"         # Replace with generated aqua API secret
  aqua_autoconnect_url   = "<aqua_autoconnect_url>"    # Aqua Autoconnect API URL
  aqua_volscan_api_token = "<aqua_volscan_api_token>"  # Aqua Volume Scanning API token
  aqua_volscan_api_url   = "<aqua_volscan_api_url>"    # Aqua Volume Scanning API URL
  dedicated_project_id   = "aqua-agentless-${local.tenant_id}-${local.org_hash}" 
  labels                 = merge(local.aqua_custom_labels, { "aqua-agentless-scanner" = "true" }) # Combined labels for Aqua resources
  org_hash               = substr(sha1(local.org_name), 0, 6) # Hashed organization name (first 6 characters)
}

################################

# Defining the root google provider
provider "google" {
  project        = local.project_id # Existing project to be onboarded
  region         = local.region
  default_labels = local.labels
}

# Creating a dedicated project for Aqua resources
module "aqua_gcp_dedicated_project" {
  source          = "aquasecurity/onboarding/gcp//modules/dedicated_project"
  org_name        = local.org_name
  project_id      = local.dedicated_project_id
  root_project_id = local.project_id
  labels          = local.labels
}

################################

# Defining the Google Cloud provider for the dedicated project
provider "google" {
  alias          = "dedicated"
  project        = module.aqua_gcp_dedicated_project.project_id
  region         = local.region
  default_labels = local.labels
}

# Creating onboarding resources on the dedicated project
module "aqua_gcp_onboarding" {
  source = "aquasecurity/onboarding/gcp"
  providers = {
    google.onboarding = google.dedicated # Using the dedicated project provider
  }
  type                   = local.type
  project_id             = module.aqua_gcp_dedicated_project.project_id # Dedicated project for Aqua resources
  region                 = local.region
  org_name               = local.org_name
  aqua_tenant_id         = local.tenant_id
  aqua_aws_account_id    = local.aqua_aws_account_id
  aqua_bucket_name       = local.aqua_bucket_name
  aqua_custom_labels     = local.aqua_custom_labels
  aqua_volscan_api_token = local.aqua_volscan_api_token
  aqua_volscan_api_url   = local.aqua_volscan_api_url
  depends_on             = [module.aqua_gcp_dedicated_project]
}

################################

## Onboarding the existing project and attaching it to the dedicated project
module "aqua_gcp_project_attachment" {
  source = "aquasecurity/onboarding/gcp//modules/project_attachment"
  providers = {
    google = google # Using the root project provider
  }
  aqua_api_key                                  = local.aqua_api_key
  aqua_api_secret                               = local.aqua_api_secret
  aqua_autoconnect_url                          = local.aqua_autoconnect_url
  aqua_bucket_name                              = local.aqua_bucket_name
  aqua_configuration_id                         = local.aqua_configuration_id
  aqua_cspm_group_id                            = local.aqua_cspm_group_id
  org_name                                      = local.org_name
  project_id                                    = local.project_id # Existing project to be onboarded
  dedicated_project                             = local.dedicated
  labels                                        = local.aqua_custom_labels
  create_role_id                                = module.aqua_gcp_onboarding.create_role_id                     # Referencing outputs from the onboarding module
  onboarding_service_account_email              = module.aqua_gcp_onboarding.service_account_email              # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_id          = module.aqua_gcp_onboarding.workload_identity_pool_id          # Referencing outputs from the onboarding module
  onboarding_workload_identity_pool_provider_id = module.aqua_gcp_onboarding.workload_identity_pool_provider_id # Referencing outputs from the onboarding module
  onboarding_project_number                     = module.aqua_gcp_onboarding.project_number                     # Referencing outputs from the onboarding module
  depends_on                                    = [module.aqua_gcp_onboarding]
}
```

For more examples and use cases, please refer to the examples folder in the repository.


## Using Existing Network and Firewall


If you prefer to use an existing network and firewall instead of creating new ones,
you can do so by setting `create_network = false` in the module's input variables.
In this case, you will need to create,
prior to onboarding, network and firewall resources with the following naming convention:


* Firewall: `<project_id>-rules-aqua-aas`
* Network: `<project_id>-network`

When using a dedicated project, the `<project_id>` should follow the format `"aqua-agentless-${local.tenant_id}-${local.org_hash}"`. 


## Using an Existing Dedicated Project

If you have an existing dedicated project that you want to use to host Aqua Security resources, you can import it into the Terraform configuration.

To do so, use the following Terraform import command:

`terraform import module.aqua_gcp_dedicated_project.google_project.project <dedicated_project_id>`


Replace `<dedicated_project_id>` with the ID of your existing dedicated project. 

It's important to note that the dedicated project ID should follow the naming convention `"aqua-agentless-${local.tenant_id}-${local.org_hash}"`, where local.org_hash is calculated as:

`org_hash = substr(sha1(<org_name>), 0, 6)`


For example, if your Aqua tenant ID is `12345` and the first six characters of the SHA1 hash of your organization name are `12a456`, the dedicated project ID should be `aqua-agentless-12345-12a456`.

You will also need to ensure that the existing dedicated project has the label `"aqua-agentless-scanner" = "true"` applied.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6.4 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.20.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_onboarding"></a> [onboarding](#module\_onboarding) | ./modules/onboarding | n/a |

## Resources

| Name | Type |
|------|------|
| [google_organization.organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_aws_account_id"></a> [aqua\_aws\_account\_id](#input\_aqua\_aws\_account\_id) | Aqua AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aqua_custom_labels"></a> [aqua\_custom\_labels](#input\_aqua\_custom\_labels) | Additional labels to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_aqua_tenant_id"></a> [aqua\_tenant\_id](#input\_aqua\_tenant\_id) | Aqua Tenant ID | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token) | Aqua Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_url"></a> [aqua\_volscan\_api\_url](#input\_aqua\_volscan\_api\_url) | Aqua volume scanning API URL | `string` | n/a | yes |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Toggle to create network resources | `bool` | `true` | no |
| <a name="input_create_role_name"></a> [create\_role\_name](#input\_create\_role\_name) | The name of the role to be created for Aqua | `string` | `"AquaAutoConnectAgentlessRole"` | no |
| <a name="input_delete_role_name"></a> [delete\_role\_name](#input\_delete\_role\_name) | The name of the role used for deleting Aqua resources | `string` | `"AutoConnectDeleteRole"` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | Name of the identity pool. If not provided, the default value is set to 'aqua-agentless-pool-<aqua\_tenant\_id>' in the 'identity\_pool\_name' local | `string` | `null` | no |
| <a name="input_identity_pool_provider_name"></a> [identity\_pool\_provider\_name](#input\_identity\_pool\_provider\_name) | Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<aqua\_tenant\_id>' in the 'identity\_pool\_provider\_name' local | `string` | `null` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Onboarding Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Main Deployment Region | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account. If not provided, the default value is set to 'aqua-agentless-sa-<aqua\_tenant\_id>' in the 'service\_account\_name' local | `string` | `null` | no |
| <a name="input_show_outputs"></a> [show\_outputs](#input\_show\_outputs) | Whether to show outputs after deployment | `bool` | `false` | no |
| <a name="input_sink_name"></a> [sink\_name](#input\_sink\_name) | Name of the sink. If not provided, the default value is set to '<project\_id>-sink' in the 'sink\_name' local | `string` | `null` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the topic. If not provided, the default value is set to '<project\_id>-topic' in the 'topic\_name' local | `string` | `null` | no |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Name of the trigger. If not provided, the default value is set to '<project\_id>-trigger' in the 'trigger\_name' local | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of onboarding. Valid values are 'single' for single organization onboarding | `string` | `"single"` | no |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | Name of the workflow. If not provided, the default value is set to '<project\_id>-workflow' in the 'workflow\_name' local | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_role_id"></a> [create\_role\_id](#output\_create\_role\_id) | Create role ID |
| <a name="output_create_role_name"></a> [create\_role\_name](#output\_create\_role\_name) | Create role name |
| <a name="output_create_role_permissions"></a> [create\_role\_permissions](#output\_create\_role\_permissions) | Permissions of the created role |
| <a name="output_delete_role_name"></a> [delete\_role\_name](#output\_delete\_role\_name) | Delete role name |
| <a name="output_delete_role_permissions"></a> [delete\_role\_permissions](#output\_delete\_role\_permissions) | Permissions of the deleted role |
| <a name="output_eventarc_trigger_destination_workflow"></a> [eventarc\_trigger\_destination\_workflow](#output\_eventarc\_trigger\_destination\_workflow) | Destination workflow for the eventarc trigger |
| <a name="output_eventarc_trigger_name"></a> [eventarc\_trigger\_name](#output\_eventarc\_trigger\_name) | Eventarc trigger name |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Firewall name |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Network name |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | Google Cloud Organization ID |
| <a name="output_org_name"></a> [org\_name](#output\_org\_name) | Google Cloud Organization name |
| <a name="output_project_api_services"></a> [project\_api\_services](#output\_project\_api\_services) | API services enabled in the project |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Google Cloud Project ID |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Google Cloud Project number |
| <a name="output_pubsub_topic_name"></a> [pubsub\_topic\_name](#output\_pubsub\_topic\_name) | Pubsub topic name |
| <a name="output_region"></a> [region](#output\_region) | Google Cloud Region |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Service account email |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | Service account ID |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Service account name |
| <a name="output_sink_name"></a> [sink\_name](#output\_sink\_name) | Sink name |
| <a name="output_workflow_name"></a> [workflow\_name](#output\_workflow\_name) | Workflow name |
| <a name="output_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#output\_workload\_identity\_pool\_id) | Workload identity pool ID |
| <a name="output_workload_identity_pool_provider_id"></a> [workload\_identity\_pool\_provider\_id](#output\_workload\_identity\_pool\_provider\_id) | Workload identity pool provider ID |
| <a name="output_workload_identity_pool_provider_id_aws_account_id"></a> [workload\_identity\_pool\_provider\_id\_aws\_account\_id](#output\_workload\_identity\_pool\_provider\_id\_aws\_account\_id) | Workload identity pool provider AWS account ID |
<!-- END_TF_DOCS -->