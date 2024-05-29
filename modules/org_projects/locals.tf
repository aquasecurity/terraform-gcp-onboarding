# modules/org_projects/locals.tf

locals {
  # Split the regex patterns into lists
  regex_ids_list   = length(var.projects_ids_exclude) > 0 ? split(",", var.projects_ids_exclude) : []
  regex_names_list = length(var.projects_names_exclude) > 0 ? split(",", var.projects_names_exclude) : []

  # Extract project IDs and names from all active projects
  filtered_projects = [
    for project in data.google_cloud_asset_search_all_resources.all_projects.results :
    split("/", project.name)[4] # Extract the project ID from the full resource name
    if !can(regex("^.*aqua-agentless.*$", project.display_name)) &&
    (length(local.regex_ids_list) == 0 || alltrue([for id_pattern in local.regex_ids_list : !can(regex(id_pattern, split("/", project.name)[4]))])) &&
    (length(local.regex_names_list) == 0 || alltrue([for name_pattern in local.regex_names_list : !can(regex(name_pattern, project.display_name))]))
  ]
}

