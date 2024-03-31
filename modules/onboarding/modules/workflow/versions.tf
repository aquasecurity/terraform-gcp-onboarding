# modules/onboarding/modules/workflow/versions.tf

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source                = "hashicorp/google"
      version               = "~> 5.20.0"
      configuration_aliases = [google.onboarding]
    }
  }
}