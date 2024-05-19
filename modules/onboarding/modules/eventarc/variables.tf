# modules/onboarding/modules/eventarc/variables.tf

variable "trigger_name" {
  description = "Name of the trigger"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "topic_name" {
  description = "Name of the Pub/Sub topic"
  type        = string
}

variable "workflow_name" {
  description = "Name of the workflow"
  type        = string
}