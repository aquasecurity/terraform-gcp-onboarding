# modules/onboarding/modules/iam/locals.tf

locals {
  # Parsing Roles permissions
  create_role_permissions = yamldecode(data.http.autoconnect_create_role_yaml.response_body).includedPermissions
  delete_role_permissions = yamldecode(data.http.autoconnect_delete_role_yaml.response_body).includedPermissions
  cspm_role_permissions   = yamldecode(data.http.autoconnect_cspm_role_yaml.response_body).includedPermissions

  # Defining role_ids
  create_role_id = var.dedicated_project ? google_organization_iam_custom_role.iam_role_create[0].id : google_project_iam_custom_role.iam_role_create[0].id
  delete_role_id = var.dedicated_project ? google_organization_iam_custom_role.iam_role_delete[0].name : google_project_iam_custom_role.iam_role_delete[0].name
  cspm_role_id   = var.type == "organization" && var.dedicated_project ? google_organization_iam_custom_role.cspm_role[0].id : null
}
