
# `cspm_iam` module

---

This Terraform module creates the IAM resources needed for organization - same deployment on Google Cloud Platform (GCP).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.30.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.30.0 |
| <a name="provider_http"></a> [http](#provider\_http) | ~> 3.4.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_organization_iam_binding.organization_iam_binding_cspm_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_binding) | resource |
| [google_organization_iam_custom_role.cspm_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_custom_role) | resource |
| [google_service_account.aqua_cspm_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.cspm_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [http_http.autoconnect_cspm_role_yaml](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aqua_tenant_id"></a> [aqua\_tenant\_id](#input\_aqua\_tenant\_id) | Aqua Tenant ID | `string` | n/a | yes |
| <a name="input_cspm_role_name"></a> [cspm\_role\_name](#input\_cspm\_role\_name) | The name of the role used for CSPM | `string` | `"AquaAutoConnectCSPMRole"` | no |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | Google Cloud Organization ID | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The Google Cloud Project ID where CSPM service account and organization IAM role will be created. This is relevant only for the 'organization - same' deployment setup. | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Name of the CSPM service account. If not provided, the default value is set to 'aqua-cspm-scanner-<aqua\_tenant\_id>' in the 'service\_account\_name' local | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cspm_role_id"></a> [cspm\_role\_id](#output\_cspm\_role\_id) | The ID of the custom IAM role created for CSPM |
| <a name="output_cspm_role_name"></a> [cspm\_role\_name](#output\_cspm\_role\_name) | The name of the custom IAM role created for CSPM |
| <a name="output_cspm_role_permissions"></a> [cspm\_role\_permissions](#output\_cspm\_role\_permissions) | The permissions associated with the custom IAM role created for CSPM |
| <a name="output_cspm_service_account_email"></a> [cspm\_service\_account\_email](#output\_cspm\_service\_account\_email) | The email of the created Google Service Account for CSPM |
| <a name="output_cspm_service_account_id"></a> [cspm\_service\_account\_id](#output\_cspm\_service\_account\_id) | The ID of the created Google Service Account for CSPM |
| <a name="output_cspm_service_account_key"></a> [cspm\_service\_account\_key](#output\_cspm\_service\_account\_key) | The key of the created Google Service Account for CSPM |
| <a name="output_cspm_service_account_name"></a> [cspm\_service\_account\_name](#output\_cspm\_service\_account\_name) | The name of the created Google Service Account for CSPM |
<!-- END_TF_DOCS -->
