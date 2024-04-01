# modules/onboarding/modules/pubsub/main.tf

# Create a Pub/Sub topic
resource "google_pubsub_topic" "pubsub_topic" {
  #checkov:skip=CKV_GCP_83:Ensure PubSub Topics are encrypted with Customer Supplied Encryption Keys (CSEK)
  name    = var.topic_name
  project = var.project_id
}

# Create a logging sink to export logs to the Pub/Sub topic
resource "google_logging_project_sink" "project_sink" {
  name        = var.sink_name
  project     = var.project_id
  destination = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.pubsub_topic.name}"
  filter      = "protoPayload.methodName=(v1.compute.regionDisks.insert OR v1.compute.disks.insert) AND resource.labels.project_id=${var.project_id} AND severity:NOTICE AND operation.last=true AND protoPayload.authenticationInfo.principalEmail=${var.service_account_email}"
}

# Grant the logging sink's writer identity the necessary IAM permissions to publish to the Pub/Sub topic
resource "google_pubsub_topic_iam_binding" "binding" {
  project = var.project_id
  topic   = google_pubsub_topic.pubsub_topic.name
  role    = "roles/pubsub.publisher"
  members = [
    google_logging_project_sink.project_sink.writer_identity,
  ]
}