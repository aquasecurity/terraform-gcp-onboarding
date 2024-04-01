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

output "root_project_billing_account" {
  value       = data.google_project.root_project.billing_account
  description = "Root Google Cloud Project Billing Account"
}
