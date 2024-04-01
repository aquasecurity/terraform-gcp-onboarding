# modules/project_attachment/client-config.tf

# Generating client-config
locals {
  client_config = {
    "type"                              = "external_account"
    "audience"                          = "//iam.googleapis.com/projects/${var.onboarding_project_number}/locations/global/workloadIdentityPools/${var.onboarding_workload_identity_pool_id}/providers/${var.onboarding_workload_identity_pool_provider_id}"
    "subject_token_type"                = "urn:ietf:params:aws:token-type:aws4_request"
    "token_url"                         = "https://sts.googleapis.com/v1/token"
    "service_account_impersonation_url" = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${var.onboarding_service_account_email}:generateAccessToken"
    "credential_source" = {
      "environment_id"                 = "aws1"
      "region_url"                     = "http://169.254.169.254/latest/meta-data/placement/availability-zone"
      "url"                            = "http://169.254.169.254/latest/meta-data/iam/security-credentials"
      "regional_cred_verification_url" = "https://sts.{region}.amazonaws.com?Action=GetCallerIdentity&Version=2011-06-15"
    }
  }
}