# modules/onboarding/modules/iam/service-agent.tf

# Bind the service account to the Eventarc eventReceiver role
resource "google_project_iam_binding" "project_iam_binding_eventarc_eventReceiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Bind the service account to the Workflows invoker role
resource "google_project_iam_binding" "project_iam_binding_workflows_invoker" {
  project = var.project_id
  role    = "roles/workflows.invoker"

  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}

# Grants the Cloud Pub/Sub service agent to the serviceAccountTokenCreator role
#trivy:ignore:AVD-GCP-0011
resource "google_project_iam_member" "pubsub_service_agent" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
