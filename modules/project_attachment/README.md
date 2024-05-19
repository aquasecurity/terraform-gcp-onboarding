
# `project_attachment` module

---

This Terraform module integrates an existing Google Cloud Platform (GCP) project with Aqua Security.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.20.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.3 |
| <a name="provider_google"></a> [google](#provider\_google) | 5.20.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_custom_role.cspm_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.project_iam_member_create_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.project_iam_member_cspm_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.project_api_services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.cspm_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.cspm_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [random_integer.cspm_service_account_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [external_external.gcp_onboarding](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.autoconnect_cspm_role_yaml](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_api_key"></a> [aqua\_api\_key](#input\_aqua\_api\_key) | Aqua API key | `string` | n/a | yes |
| <a name="input_aqua_api_secret"></a> [aqua\_api\_secret](#input\_aqua\_api\_secret) | Aqua API secret | `string` | n/a | yes |
| <a name="input_aqua_autoconnect_url"></a> [aqua\_autoconnect\_url](#input\_aqua\_autoconnect\_url) | Aqua Autoconnect API URL | `string` | n/a | yes |
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aqua_configuration_id"></a> [aqua\_configuration\_id](#input\_aqua\_configuration\_id) | Aqua Configuration ID | `string` | n/a | yes |
| <a name="input_aqua_cspm_group_id"></a> [aqua\_cspm\_group\_id](#input\_aqua\_cspm\_group\_id) | Aqua CSPM Group ID | `number` | n/a | yes |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | The name of the role used for CSPM | `string` | `"AquaAutoConnectRole"` | no |
| <a name="input_dedicated_project"></a> [dedicated\_project](#input\_dedicated\_project) | Indicates whether dedicated project is enabled | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Additional resource labels to will be send to the Autoconnect API | `map(string)` | `{}` | no |
| <a name="input_onboarding_create_role_id"></a> [onboarding\_create\_role\_id](#input\_onboarding\_create\_role\_id) | ID of the create role that has been created in the root module. This should be referenced from the root onboarding module. | `string` | `""` | no |
| <a name="input_onboarding_cspm_service_account_key"></a> [onboarding\_cspm\_service\_account\_key](#input\_onboarding\_cspm\_service\_account\_key) | The Key of the CSPM service account that has been created in the root module. This should be referenced from the root onboarding module only for organization dedicated onboarding. | `string` | `""` | no |
| <a name="input_onboarding_project_number"></a> [onboarding\_project\_number](#input\_onboarding\_project\_number) | Google Cloud Project Number has been created in the root module. This should be referenced from the root onboarding module. | `string` | n/a | yes |
| <a name="input_onboarding_service_account_email"></a> [onboarding\_service\_account\_email](#input\_onboarding\_service\_account\_email) | Email of the service account that has been created in the root module. This should be referenced from the root onboarding module. | `string` | n/a | yes |
| <a name="input_onboarding_workload_identity_pool_id"></a> [onboarding\_workload\_identity\_pool\_id](#input\_onboarding\_workload\_identity\_pool\_id) | ID of the workload identity pool that has been created in the root module. This should be referenced from the root onboarding module. | `string` | n/a | yes |
| <a name="input_onboarding_workload_identity_pool_provider_id"></a> [onboarding\_workload\_identity\_pool\_provider\_id](#input\_onboarding\_workload\_identity\_pool\_provider\_id) | ID of the workload identity pool provider that has been created in the root module. This should be referenced from the root onboarding module. | `string` | n/a | yes |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Project ID | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | The type of onboarding. Valid values are 'single' or 'organization' onboarding types | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_onboarding_status"></a> [onboarding\_status](#output\_onboarding\_status) | Onboarding API call output |
<!-- END_TF_DOCS -->
