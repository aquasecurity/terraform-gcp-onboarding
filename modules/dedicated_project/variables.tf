# modules/dedicated_project/variables.tf

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]{1,35}$", var.project_id))
    error_message = "Google Cloud Project ID must match the pattern: /^[a-z0-9-]{1,35}$/."
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

variable "billing_account_id" {
  description = "Google Cloud Billing Account ID"
  type        = string
  default     = ""
}

variable "root_project_id" {
  description = "Root Google Cloud Project ID"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Labels to add to resources"
  type        = map(string)
}
