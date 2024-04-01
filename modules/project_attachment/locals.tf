# modules/project_attachment/locals.tf

locals {
  cspm_role_permissions  = yamldecode(data.http.autoconnect_cspm_role_yaml.response_body).includedPermissions
  org_id                 = data.google_organization.organization.org_id
  service_account_key    = base64decode(google_service_account_key.aqua_service_account_key.private_key)
  client_config_rendered = replace(jsonencode(local.client_config), "/\\\\u0026/", "&")
  api_services           = ["cloudresourcemanager.googleapis.com", "iam.googleapis.com", "compute.googleapis.com"]
}