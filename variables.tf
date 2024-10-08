# variables.tf

variable "project_id" {
  description = "Google Cloud Onboarding Project ID"
  type        = string
  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty"
  }
}

variable "region" {
  description = "Google Cloud Main Deployment Region"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,35}$", var.region))
    error_message = "Region must match the pattern: /^[a-z0-9-]{1,35}$/"
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

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
  validation {
    condition     = var.type == "single" || var.type == "organization"
    error_message = "Only 'single' or 'organization' onboarding types are supported"
  }
}

variable "aqua_aws_account_id" {
  description = "Aqua AWS Account ID"
  type        = string
  validation {
    condition     = can(regex("^\\d{12}$", var.aqua_aws_account_id))
    error_message = "Aqua AWS account ID must be a 12-digit number"
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

variable "aqua_volscan_api_token" {
  description = "Aqua Volume Scanning API Token"
  type        = string
  validation {
    condition     = length(var.aqua_volscan_api_token) > 0
    error_message = "Aqua Volume Scanning API Token must not be empty"
  }
}

variable "aqua_volscan_api_url" {
  description = "Aqua Volume Scanning API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_volscan_api_url))
    error_message = "Aqua Volume Scanning API URL must start with or 'https://'"
  }
}

## CSPM variables
variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
  validation {
    condition     = length(var.aqua_bucket_name) > 0
    error_message = "Aqua Bucket Name must not be empty"
  }
}

variable "create_role_name" {
  description = "The name of the role to be created for Aqua"
  type        = string
  default     = "AquaAutoConnectAgentlessRole"
  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\.]{3,64}$", var.create_role_name))
    error_message = "Create role name must start with a letter, contain only letters, numbers, underscores, or periods, and be between 3 and 64 characters long."
  }
}

variable "delete_role_name" {
  description = "The name of the role used for deleting Aqua resources"
  type        = string
  default     = "AutoConnectDeleteRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.delete_role_name))
    error_message = "Delete role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
}

variable "cspm_role_name" {
  description = "The name of the role used for CSPM"
  type        = string
  default     = "AquaAutoConnectCSPMRole"
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.cspm_role_name))
    error_message = "CSPM role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
  }
}

variable "identity_pool_name" {
  description = "Name of the identity pool. If not provided, the default value is set to 'aqua-agentless-pool-<aqua_tenant_id>' in the 'identity_pool_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.identity_pool_name == "" || length(var.identity_pool_name) >= 4 && length(var.identity_pool_name) <= 32 && can(regex("^[a-z0-9-]+$", var.identity_pool_name)) && !startswith(var.identity_pool_name, "gcp-")
    error_message = "The identity pool name must be 4-32 characters long, contain only lowercase letters, numbers, or hyphens, and cannot start with 'gcp-'."
  }
}

variable "identity_pool_provider_name" {
  description = "Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<aqua_tenant_id>' in the 'identity_pool_provider_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.identity_pool_provider_name == "" || length(var.identity_pool_provider_name) >= 4 && length(var.identity_pool_provider_name) <= 32 && can(regex("^[a-z0-9-]+$", var.identity_pool_provider_name)) && !startswith(var.identity_pool_provider_name, "gcp-")
    error_message = "The identity pool provider name must be 4-32 characters long, may contain lowercase letters, numbers, and hyphens, but cannot start with 'gcp-'."
  }
}

variable "service_account_name" {
  description = "Name of the service account. If not provided, the default value is set to 'aqua-agentless-sa-<aqua_tenant_id>' in the 'service_account_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.service_account_name == "" || (length(var.service_account_name) >= 6 && length(var.service_account_name) <= 30 && can(regex("^[a-z]([-a-z0-9]*[a-z0-9])$", var.service_account_name)))
    error_message = "The service account name must be 6-30 characters long, start with a lowercase letter, end with a lowercase letter or number, and may contain only lowercase letters, numbers, and hyphens."
  }
}

variable "cspm_service_account_name" {
  description = "Name of the CSPM service account. If not provided, the default value is set to 'aqua-cspm-scanner-<aqua_tenant_id>' in the 'cspm_service_account_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.cspm_service_account_name == "" || (length(var.cspm_service_account_name) >= 6 && length(var.cspm_service_account_name) <= 30 && can(regex("^[a-z]([-a-z0-9]*[a-z0-9])$", var.cspm_service_account_name)))
    error_message = "When provided, the CSPM service account name must be 6-30 characters long, start with a lowercase letter, end with a lowercase letter or number, and may contain only lowercase letters, numbers, and hyphens."
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

variable "topic_name" {
  description = "Name of the topic. If not provided, the default value is set to '<project_id>-topic' in the 'topic_name' local"
  type        = string
  default     = ""
}

variable "sink_name" {
  description = "Name of the sink. If not provided, the default value is set to '<project_id>-sink' in the 'sink_name' local"
  type        = string
  default     = ""
}

variable "workflow_name" {
  description = "Name of the workflow. If not provided, the default value is set to '<project_id>-workflow' in the 'workflow_name' local"
  type        = string
  default     = ""
}

variable "trigger_name" {
  description = "Name of the trigger. If not provided, the default value is set to '<project_id>-trigger' in the 'trigger_name' local"
  type        = string
  default     = ""
}

variable "network_name" {
  description = "Name of the network. If not provided, the default value is in the 'network_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.network_name == "" || (length(var.network_name) >= 1 && length(var.network_name) <= 63 && can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", var.network_name)))
    error_message = "The network_name must be 1-63 characters long, start with a lowercase letter, end with a lowercase letter or number, and may contain only lowercase letters, numbers, and hyphens. The last character cannot be a dash."
  }
}

variable "firewall_name" {
  description = "Name of the firewall. If not provided, the default value is in the 'firewall_name' local"
  type        = string
  default     = ""
  validation {
    condition     = var.firewall_name == "" || (length(var.firewall_name) >= 1 && length(var.firewall_name) <= 63 && can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", var.firewall_name)))
    error_message = "The firewall_name must be 1-63 characters long, start with a lowercase letter, end with a lowercase letter or number, and may contain only lowercase letters, numbers, and hyphens. The last character cannot be a dash."
  }
}

variable "create_network" {
  description = "Toggle to create network resources"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.create_network))
    error_message = "Create network must be either true or false."
  }
}

variable "show_outputs" {
  description = "Whether to show outputs after deployment"
  type        = bool
  default     = false
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.show_outputs))
    error_message = "Show outputs toggle must be either true or false."
  }
}


