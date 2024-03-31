# modules/onboarding/modules/pubsub/outputs.tf

output "pubsub_topic_name" {
  value       = google_pubsub_topic.pubsub_topic.name
  description = "The name of the created Pub/Sub topic"
}

output "sink_name" {
  value       = google_logging_project_sink.project_sink.name
  description = "The name of the created logging sink"
}
