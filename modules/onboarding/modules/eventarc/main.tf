# modules/onboarding/modules/eventarc/main.tf

# Create Eventarc Trigger
resource "google_eventarc_trigger" "trigger" {
  provider        = google.onboarding
  project         = var.project_id
  name            = var.trigger_name
  location        = var.region
  service_account = var.service_account_email
  transport {
    pubsub {
      topic = "projects/${var.project_id}/topics/${var.topic_name}"
    }
  }

  destination {
    workflow = "projects/${var.project_id}/locations/${var.region}/workflows/${var.workflow_name}"
  }

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
}
