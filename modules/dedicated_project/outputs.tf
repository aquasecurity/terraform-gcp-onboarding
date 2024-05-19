# modules/dedicated_project/outputs.tf

output "project_id" {
  value       = google_project.project.project_id
  description = "Google Cloud Project ID"
}

output "project_name" {
  value       = google_project.project.name
  description = "Google Cloud Project Name"
}

output "project_number" {
  value       = google_project.project.number
  description = "Google Cloud Project Number"
}

output "billing_account" {
  value       = local.billing_account
  description = "Google Cloud Project Billing Account"
}
