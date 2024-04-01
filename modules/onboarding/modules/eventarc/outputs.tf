# modules/onboarding/modules/eventarc/outputs.tf

output "eventarc_trigger_name" {
  value       = google_eventarc_trigger.trigger.name
  description = "The name of the created Eventarc trigger"
}

output "eventarc_trigger_destination_workflow" {
  value       = google_eventarc_trigger.trigger.destination[0].workflow
  description = "The name of the Workflow associated with the Eventarc trigger"
}