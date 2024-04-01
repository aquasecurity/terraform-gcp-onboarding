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

variable "aqua_custom_labels" {
  description = "Additional labels to be applied to resources"
  type        = map(string)
  default     = {}
}

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
  validation {
    condition     = length(var.org_name) > 0
    error_message = "Org name must not be empty"
  }
}

variable "type" {
  description = "The type of onboarding. Valid values are 'single' for single organization onboarding"
  type        = string
  default     = "single"
  validation {
    condition     = var.type == "single"
    error_message = "Currently, only 'single' organization onboarding is supported"
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
  description = "Aqua volume scanning API URL"
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
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]{0,63}$", var.create_role_name))
    error_message = "Create role name must start with a letter, contain only letters, numbers, hyphens, or underscores, and be between 1 and 64 characters long."
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

variable "identity_pool_name" {
  description = "Name of the identity pool. If not provided, the default value is set to 'aqua-agentless-pool-<aqua_tenant_id>' in the 'identity_pool_name' local"
  type        = string
  default     = null
}

variable "identity_pool_provider_name" {
  description = "Name of the identity pool provider. If not provided, the default value is set to 'agentless-provider-<aqua_tenant_id>' in the 'identity_pool_provider_name' local"
  type        = string
  default     = null
}

variable "service_account_name" {
  description = "Name of the service account. If not provided, the default value is set to 'aqua-agentless-sa-<aqua_tenant_id>' in the 'service_account_name' local"
  type        = string
  default     = null
}

variable "topic_name" {
  description = "Name of the topic. If not provided, the default value is set to '<project_id>-topic' in the 'topic_name' local"
  type        = string
  default     = null
}

variable "sink_name" {
  description = "Name of the sink. If not provided, the default value is set to '<project_id>-sink' in the 'sink_name' local"
  type        = string
  default     = null
}

variable "workflow_name" {
  description = "Name of the workflow. If not provided, the default value is set to '<project_id>-workflow' in the 'workflow_name' local"
  type        = string
  default     = null
}

variable "trigger_name" {
  description = "Name of the trigger. If not provided, the default value is set to '<project_id>-trigger' in the 'trigger_name' local"
  type        = string
  default     = null
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


