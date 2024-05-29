# `org_projects` module

---

This Terraform module retrieves information about the Google Cloud Platform (GCP) organization. It fetches all project IDs, including projects nested under folders, and allows the use of regex patterns to exclude specific project IDs or project names. Note that the GCP Cloud Asset API must be enabled on the project specified in the provider block passed to this module.


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
| [google_cloud_asset_search_all_resources.all_projects](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/cloud_asset_search_all_resources) | data source |
| [google_organization.org](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/organization) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_org_name"></a> [org\_name](#input\_org\_name) | Google Cloud Organization name | `string` | n/a | yes |
| <a name="input_projects_ids_exclude"></a> [projects\_ids\_exclude](#input\_projects\_ids\_exclude) | Comma-separated list of regex patterns to exclude project IDs | `string` | `""` | no |
| <a name="input_projects_names_exclude"></a> [projects\_names\_exclude](#input\_projects\_names\_exclude) | Comma-separated list of regex patterns to exclude project names | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_projects"></a> [all\_projects](#output\_all\_projects) | All projects fetched by the data source |
| <a name="output_filtered_projects"></a> [filtered\_projects](#output\_filtered\_projects) | Google Cloud Active Project IDs, excluding those matching the given regex patterns |
| <a name="output_org_id"></a> [org\_id](#output\_org\_id) | Google Cloud Organization ID |
| <a name="output_org_name"></a> [org\_name](#output\_org\_name) | Google Cloud Organization Name |
| <a name="output_regex_ids_list"></a> [regex\_ids\_list](#output\_regex\_ids\_list) | List of regex patterns used to exclude projects by their IDs |
| <a name="output_regex_names_list"></a> [regex\_names\_list](#output\_regex\_names\_list) | List of regex patterns used to exclude projects by their display names |
<!-- END_TF_DOCS -->