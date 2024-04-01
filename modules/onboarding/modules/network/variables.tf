# modules/onboarding/modules/iam/variables.tf

variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "network_name" {
  description = "Name of the network"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}