# modules/dedicated_project/variables.tf

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
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
