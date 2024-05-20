# modules/cspm_iam/data.tf

# Retrieve the YAML file containing the Aqua CSPM role definition
data "http" "autoconnect_cspm_role_yaml" {
  url = "https://${var.aqua_bucket_name}.s3.amazonaws.com/autoconnect_gcp_cspm_role.yaml"
}