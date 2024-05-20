# modules/cspm_iam/versions.tf

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source                = "hashicorp/google"
      version               = "~> 5.20.0"
      configuration_aliases = [google]
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
  }
}