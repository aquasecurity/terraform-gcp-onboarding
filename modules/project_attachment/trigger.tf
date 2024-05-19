# modules/project_attachment/trigger.tf

# Calling onboarding API
data "external" "gcp_onboarding" {
  program = ["python3", "${path.module}/trigger-gcp.py"]

  query = {
    api_key                  = sensitive(var.aqua_api_key)
    api_secret               = sensitive(var.aqua_api_secret)
    autoconnect_url          = var.aqua_autoconnect_url
    service_account_key      = local.service_account_key
    client_config            = local.client_config_rendered
    cspm_group_id            = var.aqua_cspm_group_id
    project_id               = var.project_id
    configuration_id         = var.aqua_configuration_id
    organization_onboarding  = var.type == "organization" ? "True" : "False"
    scan_mode                = var.dedicated_project ? "Dedicated-Project" : "Same-Project"
    organization_id          = var.type == "single" && !var.dedicated_project ? "" : var.org_name
    additional_resource_tags = join(",", [for key, value in var.labels : "${key}:${value}"])
  }
  depends_on = [local.service_account_key, local.client_config_rendered, google_project_iam_member.project_iam_member_create_role]
}



