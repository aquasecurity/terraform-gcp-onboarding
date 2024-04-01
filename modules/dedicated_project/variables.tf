# modules/dedicated_project/variables.tf

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
}

variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "root_project_id" {
  description = "Root Google Cloud Project ID"
  type        = string
}

variable "labels" {
  description = "Labels to add to resources"
  type        = map(string)
}
