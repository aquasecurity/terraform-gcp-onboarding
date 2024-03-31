# modules/onboarding/modules/workflow/outputs.tf

output "workflow_name" {
  description = "Name of the created workflow"
  value       = google_workflows_workflow.workflows_workflow.name
}