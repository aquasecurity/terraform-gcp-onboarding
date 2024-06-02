# modules/dedicated/versions.tf

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30.0"
    }
  }
}