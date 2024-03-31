# modules/onboarding/locals.tf

locals {
  # Setting required apis
  required_apis = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
    "compute.googleapis.com",
    "pubsub.googleapis.com",
    "workflowexecutions.googleapis.com",
    "logging.googleapis.com",
    "eventarc.googleapis.com"
  ]
}

