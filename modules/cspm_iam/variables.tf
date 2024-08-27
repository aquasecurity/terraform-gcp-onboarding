# modules/cspm_iam/variables.tf

variable "project_id" {
  description = "The Google Cloud Project ID where CSPM service account and organization IAM role will be created. This is relevant only for the 'organization - same' deployment setup."
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
  default     = "AquaAutoConnectCSPMRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.cspm_role_name))
    error_message = "Delete role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
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

variable "cspm_service_account_name" {
  description = "Name of the CSPM service account. If not provided, the default value is set to 'aqua-cspm-scanner-<aqua_tenant_id>' in the 'service_account_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.cspm_service_account_name == "" || (length(var.cspm_service_account_name) >= 6 && length(var.cspm_service_account_name) <= 30 && can(regex("^[a-z]([-a-z0-9]*[a-z0-9])$", var.cspm_service_account_name)))
    error_message = "The CSPM service account name must be 6-30 characters long, start with a lowercase letter, end with a lowercase letter or number, and may contain only lowercase letters, numbers, and hyphens."
  }
}

variable "org_id" {
  description = "Google Cloud Organization ID"
  type        = string
  validation {
    condition     = length(var.org_id) > 0
    error_message = "Org ID must not be empty"
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

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
  validation {
    condition     = length(var.aqua_bucket_name) > 0
    error_message = "Aqua Bucket Name must not be empty"
  }
}