# modules/org_projects/outputs.tf

output "org_id" {
  value       = data.google_organization.org.org_id
  description = "Google Cloud Organization ID"
}

output "org_name" {
  value       = data.google_organization.org.domain
  description = "Google Cloud Organization Name"
}

output "regex_ids_list" {
  value       = local.regex_ids_list
  description = "List of regex patterns used to exclude projects by their IDs"
}

output "regex_names_list" {
  value       = local.regex_names_list
  description = "List of regex patterns used to exclude projects by their display names"
}

output "all_projects" {
  value       = data.google_cloud_asset_search_all_resources.all_projects.results
  description = "All projects fetched by the data source"
}

output "filtered_projects" {
  value       = local.filtered_projects
  description = "Google Cloud Active Project IDs, excluding those matching the given regex patterns"
}