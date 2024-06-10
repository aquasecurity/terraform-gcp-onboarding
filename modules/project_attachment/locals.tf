# modules/project_attachment/locals.tf

locals {
  cspm_role_permissions       = var.type == "single" ? yamldecode(data.http.autoconnect_cspm_role_yaml[0].response_body).includedPermissions : null
  cspm_service_account_name   = var.cspm_service_account_name != null ? var.cspm_service_account_name : "aqua-cspm-scanner-${var.aqua_tenant_id}"
  cspm_service_account_email  = var.create_service_account ? google_service_account.cspm_service_account[0].email : data.google_service_account.cspm_service_account[0].email
  service_account_key         = var.type == "organization" || (!var.create_service_account && var.type == "single") ? base64decode(nonsensitive(var.onboarding_cspm_service_account_key)) : base64decode(google_service_account_key.cspm_service_account_key[0].private_key)
  client_config_rendered      = replace(jsonencode(local.client_config), "/\\\\u0026/", "&")
  api_services                = var.type == "single" ? ["cloudresourcemanager.googleapis.com", "iam.googleapis.com", "compute.googleapis.com"] : ["cloudresourcemanager.googleapis.com", "storage.googleapis.com", "compute.googleapis.com"]
}