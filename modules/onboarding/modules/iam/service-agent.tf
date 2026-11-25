# modules/onboarding/modules/iam/service-agent.tf

# Bind the service account to the Eventarc eventReceiver role
resource "google_project_iam_member" "project_iam_member_eventarc_eventReceiver" {
  project = var.project_id
  role    = "roles/eventarc.eventReceiver"

  member = "serviceAccount:${local.service_account_email}"
}

# Bind the service account to the Workflows invoker role
resource "google_project_iam_member" "project_iam_member_workflows_invoker" {
  project = var.project_id
  role    = "roles/workflows.invoker"

  member = "serviceAccount:${local.service_account_email}"
}

# Grants the Cloud Pub/Sub service agent to the serviceAccountTokenCreator role
#trivy:ignore:AVD-GCP-0011
resource "google_project_iam_member" "pubsub_service_agent" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
