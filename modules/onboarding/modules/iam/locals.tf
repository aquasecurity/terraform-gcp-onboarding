# modules/onboarding/modules/iam/locals.tf

locals {
  # Parsing Roles permissions
  create_role_permissions = yamldecode(data.http.autoconnect_create_role_yaml.response_body).includedPermissions
  delete_role_permissions = yamldecode(data.http.autoconnect_delete_role_yaml.response_body).includedPermissions
}
