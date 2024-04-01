# modules/onboarding/modules/pubsub/variables.tf

variable "topic_name" {
  description = "The name of the Pub/Sub topic to create"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "sink_name" {
  description = "The name of the logging sink to create"
  type        = string
}

variable "service_account_email" {
  description = "The email address of the service account associated with the logging sink"
  type        = string
}