# modules/project_attachment/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "aqua_tenant_id" {
  description = "Aqua Tenant ID"
  type        = string
  validation {
    condition     = length(var.aqua_tenant_id) > 0
    error_message = "Aqua Tenant ID must not be empty"
  }
}

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
  validation {
    condition     = var.type == "single" || var.type == "organization"
    error_message = "Only 'single' or 'organization' onboarding types are supported"
  }
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
  default     = "AquaAutoConnectRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.cspm_role_name))
    error_message = "Delete role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
}

variable "cspm_service_account_name" {
  description = "Name of the CSPM service account. If not provided, the default value is set to 'aqua-cspm-scanner-<aqua_tenant_id>' in the 'cspm_service_account_name' local"
  type        = string
  default     = null
}

variable "create_service_account" {
  description = "Toggle to create service account"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.create_service_account))
    error_message = "Create service account must be either true or false."
  }
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
  validation {
    condition     = var.aqua_api_key != "<REPLACE_ME>"
    error_message = "Aqua API key must be replaced from its default value of <REPLACE_ME>"
  }
}

variable "aqua_api_secret" {
  description = "Aqua API secret"
  type        = string
  validation {
    condition     = length(var.aqua_api_secret) > 0
    error_message = "Aqua API secret must not be empty"
  }
  validation {
    condition     = var.aqua_api_secret != "<REPLACE_ME>"
    error_message = "Aqua API secret must be replaced from its default value of <REPLACE_ME>"
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
}

variable "onboarding_organization_projects" {
  type        = list(string)
  description = "List of all organization IDs (This should be provided only if type of onboarding is 'organization')"
  default     = []
}

variable "labels" {
  description = "Additional resource labels to will be send to the Autoconnect API"
  type        = map(string)
  default     = {}
}

variable "onboarding_create_role_id" {
  description = "ID of the create role that has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_create_role_id) > 0
    error_message = "Onboarding create role ID must not be empty"
  }
}

variable "onboarding_project_number" {
  description = "Google Cloud Project Number has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_project_number) > 0
    error_message = "Onboarding Google Cloud Project Number must not be empty"
  }
}

variable "onboarding_project_id" {
  description = "Google Cloud Project ID has been created in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_project_id) > 0
    error_message = "Onboarding Google Cloud Project ID must not be empty"
  }
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
  description = "Email of the service account that has been created or fetched (in case that var.create_service_account is false) in the root module. This should be referenced from the root onboarding module."
  type        = string
  validation {
    condition     = length(var.onboarding_service_account_email) > 0
    error_message = "Onboarding service account email must not be empty"
  }
}

variable "onboarding_cspm_service_account_key" {
  description = "The base64 encoded Key of the CSPM service account that has been created or supplied (in case that var.create_service_account is false) in the root module. This should be referenced from the root onboarding module only for organization dedicated onboarding."
  type        = string
  default     = ""
  sensitive   = true
}

variable "onboarding_firewall_name" {
  description = "Firewall name created in the root module"
  type        = string
}

variable "onboarding_dedicated_project_name" {
  description = "Google Cloud Dedicated Project Name (This should be provided only if var.dedicated_project is 'true')"
  type        = string
  default     = null
}