# modules/onboarding/modules/services/variables.tf

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "required_apis" {
  description = "List of required APIs to be enabled in the project"
  type        = list(string)
}