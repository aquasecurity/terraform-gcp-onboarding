# modules/onboarding/modules/iam/versions.tf

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source                = "hashicorp/google"
      version               = "~> 5.30.0"
      configuration_aliases = [google.onboarding]
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
  }
}