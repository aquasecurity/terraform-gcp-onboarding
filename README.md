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
- [Providing Project ID List](#providing-project-id-list)
- [Excluding Projects Using Regex](#excluding-projects-using-regex)
- [Using Existing Dedicated Project](#using-an-existing-dedicated-project)
- [Using Existing Network](#using-existing-network-and-firewall)
- [Using Existing Service Accounts](#using-existing-service-accounts)
- [Customizing resource names](#customizing-resource-names)

## Pre-requisites

Before using this module, ensure that you have the following:

- Terraform version `1.6.4` or later.
- `gcloud` CLI installed and configured.
- `Python` 3+ installed.
- Aqua Security account API credentials.

## Usage
1. Leverage the Aqua platform to generate the local variables required by the module.
2. Important: Replace `aqua_api_key` and `aqua_api_secret` with your generated API credentials.
3. Run `terraform init` to initialize the module.
4. Run `terraform apply` to create the resources.

## Examples

* [Onboarding a Single Project using a dedicated project](https://github.com/aquasecurity/terraform-gcp-onboarding/tree/main/examples/single-dedicated-project)
* [Onboarding an Organization using a dedicated project](https://github.com/aquasecurity/terraform-gcp-onboarding/tree/main/examples/organization-dedicated-project)

For more examples and use cases, please refer to the examples folder in the repository.

## Providing Project ID List

By default, we fetch all active projects and use that project list, but you can also provide your own list of project IDs by populating the `projects_list` local. To accommodate this, ensure to remove the `module.aqua_gcp_org_projects` and then replace the local `projects_list` with your list.

```hcl
locals {
projects_list = [
  "my-project-id-1",
  "my-project-id-2",
  // Add more project IDs as needed
]
}
```

## Excluding Projects Using Regex

You can exclude specific projects from getting onboarded by using regular expressions.

To exclude projects by id, add the variable `projects_ids_exclude="regex1, regex2, regex3"` to the module `aqua_gcp_org_projects`.

To exclude projects by name, add the variable `projects_names_exclude="regex1, regex2, regex3"` to the module `aqua_gcp_org_projects`.

Here are some examples of traditional exclusions following the instructions above:

1. Exclude Projects Starting with `test-`:
    - Regex: `^test-.*$`
    - Description: This regex pattern matches GCP project names that start with `test-`.

2. Exclude Projects Ending with `-test`:
    - Regex: `^.*-test$`
    - Description: This regex pattern matches GCP project names that end with `-test`.

3. Exclude Projects which include test anywhere:
    - Regex: `.*test.*`
    - Description: This regex pattern matches GCP project names containing the word `test` anywhere in the name.

## Using an Existing Dedicated Project

If you have an existing dedicated project that you want to use to host Aqua Security resources, you can import it into the Terraform configuration.

To do so, use the following Terraform import command:

`terraform import module.aqua_gcp_dedicated_project.google_project.project <dedicated_project_id>`


Replace `<dedicated_project_id>` with the ID of your existing dedicated project.

It's important to note that the dedicated project ID should follow the naming convention `"aqua-agentless-${local.tenant_id}-${local.org_hash}"`, where local.org_hash is calculated as:

`org_hash = substr(sha1(<org_name>), 0, 6)`

You can also check for the naming convention using the bash command:

```bash
#!/bin/bash

# Replace with your Aqua tenant ID
TENANT_ID="<your_tenant_id>"

# Replace with your organization name
ORG_NAME="<your_org_name>"

# Calculate the org_hash
ORG_HASH=$(echo -n "${ORG_NAME}" | shasum -a 1 | awk '{ print $1 }' | cut -c1-6)

# Print the dedicated project ID naming convention
echo "aqua-agentless-${TENANT_ID}-${ORG_HASH}"                                    
```

For example, if your Aqua tenant ID is `12345` and the first six characters of the SHA1 hash of your organization name are `12a456`, the dedicated project ID should be `aqua-agentless-12345-12a456`.


## Using Existing Network and Firewall

If you prefer to use an existing network and firewall instead of creating new ones,
you can do so by setting `create_network = false` in the onboarding module input variables.
In this case, you will need to create,
prior to onboarding, network and firewall resources with the following naming convention:

### Dedicated project:
* **Firewall**: `<project_id>-rules-aqua-aas`
* **Network**: `<project_id>-network`

### Same project:
* **Firewall**: `<project_id>-rules-<aqua_tenant_id>aqua-aas`
* **Network**: `<project_id>-network-<aqua_tenant_id>`

When using a dedicated project, the `<project_id>` should follow the format `"aqua-agentless-${local.tenant_id}-${local.org_hash}"` as mentioned above.


## Using Existing Service Accounts

By default, this module creates the necessary service accounts for you.

However, you can use existing service accounts by adding the flag `create_service_account = false` in the module’s input variables.

In dedicated project mode, ensure to create the service accounts within your provided dedicated project. Refer to the section [Using Dedicated Project](#using-an-existing-dedicated-project) for guidance on this setup.

Prior to onboarding, create the required service account and service account key resources with the following configurations:

### Service Account Configuration
- **CSPM Service Account Name**: `aqua-cspm-scanner-<aqua_tenant_id>`
- **CSPM Service Account Project ID**:
   - Same: `<project_id>`
   - Dedicated: `<dedicated_project_id>`
- **CSPM Service Account Key Format**: `json`
- **Agentless Service Account Name**: `aqua-agentless-sa-<aqua_tenant_id>`
- **Agentless Service Account Project ID**:
   - Same: each `<project_id>`
   - Dedicated: `<dedicated_project_id>`


After creating the required resources, supply the base64 encoded service account key for the CSPM service account in the `onboarding_cspm_service_account_key` parameter in the `aqua_gcp_projects_attachment` module. 
Ensure to set `create_service_account` to `false` in both `aqua_gcp_onboarding` and `aqua_gcp_projects_attachment` modules, as well as `aqua_gcp_cspm_iam` module during organization same project mode, to skip the creation of service accounts.

For example:

```hcl
module "aqua_gcp_onboarding" {
   source = "../../"
   #(unchanged)  
   create_service_account  = false # Set to false to skip service accounts creation
   #(unchanged) 
}

module "aqua_gcp_projects_attachment" {
   source = "../../modules/project_attachment"
   #(unchanged) 
   create_service_account               = false                                   # Set to false to skip service accounts creation
   onboarding_cspm_service_account_key  = "<base64-encoded-service-account-key>"  # Referencing CSPM base64 encoded service account key created prior to onboarding
  # You can optionally provide a decrypted service account key and use filebase64 function to encode it
  # onboarding_cspm_service_account_key = filebase64("${path.module}/decoded_service_account_key.json")
  #(unchanged) 
}
```

## Customizing resource names

This module allows you to customize the names of various resources / variables, ensuring alignment with your organization's naming conventions.

Before setting custom names, please ensure they comply with each resource's specific naming policies and constraints as defined by GCP. To read more about naming conventions and standards, [please see GCP documentation](https://cloud.google.com/compute/docs/naming-resources).

### Available Customization Options:

- **Dedicated Project ID**:
    - `dedicated_project_id = "custom-dedicated-project-id"`
    - Applicable in dedicated mode.
    - To be set in the `locals` block.

- **Firewall Name**:
    - `firewall_name = "custom-firewall-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Identity Pool Name**:
    - `identity_pool_name = "custom-identity-pool-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Identity Pool Provider Name**:
    - `identity_pool_provider_name = "custom-identity-pool-provider-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Topic Name**:
    - `topic_name = "custom-topic-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Workflow Name**:
    - `workflow_name = "custom-workflow-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Network Name**:
    - `network_name = "custom-network-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Trigger Name**:
    - `trigger_name = "custom-trigger-name"`
    - To be set in the `aqua_gcp_onboarding` module.

- **Role Names**:
    - **Create Role**:
        - `create_role_name = "custom_create_role_name"`
        - To be set in the `aqua_gcp_onboarding` module.
    - **Delete Role**:
        - `delete_role_name = "custom_delete_role_name"`
        - To be set in the `aqua_gcp_onboarding` module.
  - **CSPM Role**:
      - `cspm_role_name = "custom_cspm_role_name"`
    - Set based on your setup:
        - **Organization Dedicated**: Set in the `aqua_gcp_onboarding` module.
        - **Organization Same**: Set in the `aqua_gcp_cspm_iam` module.
        - **Single Project (dedicated and same)**: Set in the `aqua_gcp_project_attachment` module.

- **Service Account Names**:
    - **Volume Scan Service Account**:
        - `service_account_name = "custom-service-account-name"`
        - To be set in the `aqua_gcp_onboarding` module.
    - **CSPM Service Account**:
        - `cspm_service_account_name = "custom-service-account-name"`
        - Set based on your setup:
            - **Organization Dedicated**: Set in the `aqua_gcp_onboarding` module.
            - **Organization Same**: Set in the `aqua_gcp_cspm_iam` module.
            - **Single Project (dedicated and same)**: Set in the `aqua_gcp_project_attachment` module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.30.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.30.0 |

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
| <a name="input_aqua_tenant_id"></a> [aqua\_tenant\_id](#input\_aqua\_tenant\_id) | Aqua Tenant ID | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token) | Aqua Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_url"></a> [aqua\_volscan\_api\_url](#input\_aqua\_volscan\_api\_url) | Aqua Volume Scanning API URL | `string` | n/a | yes |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Toggle to create network resources | `bool` | `true` | no |
| <a name="input_create_role_name"></a> [create\_role\_name](#input\_create\_role\_name) | The name of the role to be created for Aqua | `string` | `"AquaAutoConnectAgentlessRole"` | no |
| <a name="input_create_service_account"></a> [create\_service\_account](#input\_create\_service\_account) | Toggle to create service account | `bool` | `true` | no |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | The name of the role used for CSPM | `string` | `"AquaAutoConnectCSPMRole"` | no |
| <a name="input_cspm_service_account_name"></a> [cspm\_service\_account\_name](#input\_cspm\_service\_account\_name) | Name of the CSPM service account. If not provided, the default value is set to 'aqua-cspm-scanner-<aqua\_tenant\_id>' in the 'cspm\_service\_account\_name' local | `string` | `""` | no |
| <a name="input_dedicated_project"></a> [dedicated\_project](#input\_dedicated\_project) | Indicates whether dedicated project is enabled | `bool` | `true` | no |
| <a name="input_delete_role_name"></a> [delete\_role\_name](#input\_delete\_role\_name) | The name of the role used for deleting Aqua resources | `string` | `"AutoConnectDeleteRole"` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall. If not provided, the default value is in the 'firewall\_name' local | `string` | `""` | no |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | Name of the identity pool. If not provided, the default value is set to 'aqua-agentless-pool-<aqua\_tenant\_id>' in the 'identity\_pool\_name' local | `string` | `""` | no |
| <a name="input_identity_pool_provider_name"></a> [identity\_pool\_provider\_name](#input\_identity\_pool\_provider\_name) | Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<aqua\_tenant\_id>' in the 'identity\_pool\_provider\_name' local | `string` | `""` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the network. If not provided, the default value is in the 'network\_name' local | `string` | `""` | no |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Onboarding Project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Main Deployment Region | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account. If not provided, the default value is set to 'aqua-agentless-sa-<aqua\_tenant\_id>' in the 'service\_account\_name' local | `string` | `""` | no |
| <a name="input_show_outputs"></a> [show\_outputs](#input\_show\_outputs) | Whether to show outputs after deployment | `bool` | `false` | no |
| <a name="input_sink_name"></a> [sink\_name](#input\_sink\_name) | Name of the sink. If not provided, the default value is set to '<project\_id>-sink' in the 'sink\_name' local | `string` | `""` | no |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the topic. If not provided, the default value is set to '<project\_id>-topic' in the 'topic\_name' local | `string` | `""` | no |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Name of the trigger. If not provided, the default value is set to '<project\_id>-trigger' in the 'trigger\_name' local | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of onboarding. Valid values are 'single' or 'organization' onboarding types | `string` | n/a | yes |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | Name of the workflow. If not provided, the default value is set to '<project\_id>-workflow' in the 'workflow\_name' local | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_role_id"></a> [create\_role\_id](#output\_create\_role\_id) | Create role ID |
| <a name="output_create_role_name"></a> [create\_role\_name](#output\_create\_role\_name) | Create role name |
| <a name="output_create_role_permissions"></a> [create\_role\_permissions](#output\_create\_role\_permissions) | Permissions of the created role |
| <a name="output_cspm_role_id"></a> [cspm\_role\_id](#output\_cspm\_role\_id) | CSPM role ID |
| <a name="output_cspm_role_name"></a> [cspm\_role\_name](#output\_cspm\_role\_name) | CSPM role name |
| <a name="output_cspm_role_permissions"></a> [cspm\_role\_permissions](#output\_cspm\_role\_permissions) | Permissions of the CSPM role |
| <a name="output_cspm_service_account_email"></a> [cspm\_service\_account\_email](#output\_cspm\_service\_account\_email) | CSPM Service account email |
| <a name="output_cspm_service_account_id"></a> [cspm\_service\_account\_id](#output\_cspm\_service\_account\_id) | CSPM Service account ID |
| <a name="output_cspm_service_account_key"></a> [cspm\_service\_account\_key](#output\_cspm\_service\_account\_key) | CSPM Service account key |
| <a name="output_cspm_service_account_name"></a> [cspm\_service\_account\_name](#output\_cspm\_service\_account\_name) | CSPM Service account name |
| <a name="output_custom_firewall_name"></a> [custom\_firewall\_name](#output\_custom\_firewall\_name) | Firewall Name. This will be the value of var.firewall\_name if set; otherwise, it will be ''. |
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