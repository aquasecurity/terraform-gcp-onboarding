# modules/cspm_iam/locals.tf

locals {
  # Parsing Roles permissions
  cspm_role_permissions     = yamldecode(data.http.autoconnect_cspm_role_yaml.response_body).includedPermissions
  cspm_service_account_name = var.service_account_name == null ? "aqua-cspm-scanner-${var.aqua_tenant_id}" : var.service_account_name
  cspm_role_id              = google_organization_iam_custom_role.cspm_role.id
}
