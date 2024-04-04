# modules/project_attachment/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "create_role_id" {
  description = "ID of the create role that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  default     = ""
}

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
  validation {
    condition     = length(var.aqua_bucket_name) > 0
    error_message = "Aqua Bucket Name must not be empty"
  }
}

variable "aqua_api_key" {
  description = "Aqua API key"
  type        = string
  validation {
    condition     = length(var.aqua_api_key) > 0
    error_message = "Aqua API key must not be empty"
  }
}

variable "aqua_api_secret" {
  description = "Aqua API secret"
  type        = string
  validation {
    condition     = length(var.aqua_api_secret) > 0
    error_message = "Aqua API secret must not be empty"
  }
}

variable "aqua_autoconnect_url" {
  description = "Aqua Autoconnect API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_autoconnect_url))
    error_message = "Aqua Autoconnect API URL must start with or 'https://'"
  }
}

variable "aqua_cspm_group_id" {
  description = "Aqua CSPM Group ID"
  type        = number
  validation {
    condition     = var.aqua_cspm_group_id != null
    error_message = "Aqua CSPM Group ID must not be empty"
  }
}

variable "aqua_configuration_id" {
  description = "Aqua Configuration ID"
  type        = string
  validation {
    condition     = length(var.aqua_configuration_id) > 0
    error_message = "Aqua Configuration ID must not be empty"
  }
}

variable "dedicated_project" {
  description = "Indicates whether dedicated project is enabled"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.dedicated_project))
    error_message = "Dedicated project toggle must be either true or false."
  }
}

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
  validation {
    condition     = length(var.org_name) > 0
    error_message = "Org name must not be empty"
  }
}

variable "labels" {
  description = "Additional resource labels to will be send to the Autoconnect API"
  type        = map(string)
  default     = {}
}

variable "onboarding_project_number" {
  description = "Google Cloud Project Number has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
}

variable "onboarding_workload_identity_pool_provider_id" {
  description = "ID of the workload identity pool provider that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_workload_identity_pool_provider_id) > 0
    error_message = "Onboarding workload identity pool provider id must not be empty"
  }
}

variable "onboarding_workload_identity_pool_id" {
  description = "ID of the workload identity pool that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_workload_identity_pool_id) > 0
    error_message = "Onboarding workload identity pool id must not be empty"
  }
}

variable "onboarding_service_account_email" {
  description = "Email of the service account that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_service_account_email) > 0
    error_message = "Onboarding service account email must not be empty"
  }
}