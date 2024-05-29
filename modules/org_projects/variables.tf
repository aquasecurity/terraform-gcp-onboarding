# modules/org_projects/variables.tf

variable "org_name" {
  description = "Google Cloud Organization name"
  type        = string
}

variable "projects_ids_exclude" {
  description = "Comma-separated list of regex patterns to exclude project IDs"
  type        = string
  default     = ""
}

variable "projects_names_exclude" {
  description = "Comma-separated list of regex patterns to exclude project names"
  type        = string
  default     = ""
}