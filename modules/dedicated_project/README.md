# `dedicated_project` module

---
This Terraform module creates a dedicated Google Cloud Platform (GCP) project within a specified organization for deploying Aqua Security resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_organization.organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |
| [google_project.root_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | Google Cloud Billing Account ID | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to add to resources | `map(string)` | n/a | yes |
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Google Cloud Project ID | `string` | n/a | yes |
| <a name="input_root_project_id"></a> [root\_project\_id](#input\_root\_project\_id) | Root Google Cloud Project ID | `string` | `""` | no |
| <a name="input_type"></a> [type](#input\_type) | The type of onboarding. Valid values are 'single' or 'organization' onboarding types | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_account"></a> [billing\_account](#output\_billing\_account) | Google Cloud Project Billing Account |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | Google Cloud Project ID |
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Google Cloud Project Name |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | Google Cloud Project Number |
<!-- END_TF_DOCS -->
