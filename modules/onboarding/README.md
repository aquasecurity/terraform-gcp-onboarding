# `onboarding` module

---

This Terraform module provisions the essential Google Cloud Platform (GCP) infrastructure and configurations to deploy and integrate Aqua Security.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.20.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventarc"></a> [eventarc](#module\_eventarc) | ./modules/eventarc | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ./modules/iam | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_pubsub"></a> [pubsub](#module\_pubsub) | ./modules/pubsub | n/a |
| <a name="module_services"></a> [services](#module\_services) | ./modules/services | n/a |
| <a name="module_workflow"></a> [workflow](#module\_workflow) | ./modules/workflow | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_aws_account_id"></a> [aqua\_aws\_account\_id](#input\_aqua\_aws\_account\_id) | Aqua AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token) | Aqua Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_url"></a> [aqua\_volscan\_api\_url](#input\_aqua\_volscan\_api\_url) | Aqua Volume Scanning API URL | `string` | n/a | yes |
| <a name="input_create_network"></a> [create\_network](#input\_create\_network) | Toggle to create network resources | `bool` | n/a | yes |
| <a name="input_create_role_name"></a> [create\_role\_name](#input\_create\_role\_name) | The name of the role to be created for Aqua | `string` | n/a | yes |
| <a name="input_delete_role_name"></a> [delete\_role\_name](#input\_delete\_role\_name) | The name of the role used for deleting Aqua resources | `string` | n/a | yes |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create the onboarding resources | `bool` | `true` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the firewall | `string` | n/a | yes |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | The name of the identity pool | `string` | n/a | yes |
| <a name="input_identity_pool_provider_name"></a> [identity\_pool\_provider\_name](#input\_identity\_pool\_provider\_name) | The name of the identity pool provider | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the network | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Google Cloud Organization ID | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Project ID | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | Google Cloud Project Number | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Google Cloud Region | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the service account | `string` | n/a | yes |
| <a name="input_sink_name"></a> [sink\_name](#input\_sink\_name) | Name of the sink | `string` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | Name of the Pub/Sub topic | `string` | n/a | yes |
| <a name="input_trigger_name"></a> [trigger\_name](#input\_trigger\_name) | Name of the trigger | `string` | n/a | yes |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | Name of the workflow | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_create_role_id"></a> [create\_role\_id](#output\_create\_role\_id) | The ID of the custom IAM role created for the 'create' operation by the iam module |
| <a name="output_create_role_name"></a> [create\_role\_name](#output\_create\_role\_name) | The name of the custom IAM role created for the 'create' operation by the iam module |
| <a name="output_create_role_permissions"></a> [create\_role\_permissions](#output\_create\_role\_permissions) | The list of permissions associated with the custom IAM role created for the 'create' operation by the iam module |
| <a name="output_delete_role_id"></a> [delete\_role\_id](#output\_delete\_role\_id) | The ID of the custom IAM role created for the 'delete' operation by the iam module |
| <a name="output_delete_role_name"></a> [delete\_role\_name](#output\_delete\_role\_name) | The name of the custom IAM role created for the 'delete' operation by the iam module |
| <a name="output_delete_role_permissions"></a> [delete\_role\_permissions](#output\_delete\_role\_permissions) | The list of permissions associated with the custom IAM role created for the 'delete' operation by the iam module |
| <a name="output_eventarc_trigger_destination_workflow"></a> [eventarc\_trigger\_destination\_workflow](#output\_eventarc\_trigger\_destination\_workflow) | The name of the Cloud Workflows workflow associated with the Eventarc trigger created by the eventarc module |
| <a name="output_eventarc_trigger_name"></a> [eventarc\_trigger\_name](#output\_eventarc\_trigger\_name) | The name of the Eventarc trigger created by the eventarc module |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | The name of the firewall rule created by the network module |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | The name of the network created by the network module |
| <a name="output_project_api_services"></a> [project\_api\_services](#output\_project\_api\_services) | The list of Google Cloud API services enabled by the services module |
| <a name="output_pubsub_topic_name"></a> [pubsub\_topic\_name](#output\_pubsub\_topic\_name) | The name of the Cloud Pub/Sub topic created by the pubsub module |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | The email address of the service account created by the iam module |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | The ID of the service account created by the iam module |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | The name of the service account created by the iam module |
| <a name="output_sink_name"></a> [sink\_name](#output\_sink\_name) | The name of the logging sink created by the pubsub module |
| <a name="output_workflow_name"></a> [workflow\_name](#output\_workflow\_name) | The name of the Cloud Workflows workflow created by the workflow module |
| <a name="output_workload_identity_pool_id"></a> [workload\_identity\_pool\_id](#output\_workload\_identity\_pool\_id) | The ID of the Workload Identity Pool created by the iam module |
| <a name="output_workload_identity_pool_provider_id"></a> [workload\_identity\_pool\_provider\_id](#output\_workload\_identity\_pool\_provider\_id) | The ID of the Workload Identity Pool Provider created by the iam module |
| <a name="output_workload_identity_pool_provider_id_aws_account_id"></a> [workload\_identity\_pool\_provider\_id\_aws\_account\_id](#output\_workload\_identity\_pool\_provider\_id\_aws\_account\_id) | The AWS account ID associated with the Workload Identity Pool Provider created by the iam module |
<!-- END_TF_DOCS -->
