# modules/project_attachment/trigger.tf

# Calling onboarding API
data "external" "gcp_onboarding" {
  program = ["python3", "${path.module}/trigger-gcp.py"]

  query = {
    api_key                  = var.aqua_api_key
    api_secret               = var.aqua_api_secret
    autoconnect_url          = var.aqua_autoconnect_url
    service_account_key      = local.service_account_key
    client_config            = local.client_config_rendered
    cspm_group_id            = var.aqua_cspm_group_id
    configuration_id         = var.aqua_configuration_id
    scan_mode                = var.dedicated_project ? "Dedicated-Project" : "Same-Project"
    organization_id          = var.dedicated_project ? local.org_id : ""
    additional_resource_tags = join(",", [for key, value in var.labels : "${key}:${value}"])
  }
  depends_on = [local.service_account_key, local.client_config_rendered, google_project_iam_member.service_account_role, google_service_account_key.aqua_service_account_key, google_project_iam_member.service_account_role, google_project_iam_binding.project_iam_binding_create_role]
}



