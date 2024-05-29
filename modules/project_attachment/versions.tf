# modules/project_attachment/versions.tf

terraform {
  required_version = ">= 1.6.4"
  required_providers {
    google = {
      source                = "hashicorp/google"
      version               = "~> 5.30.0"
      configuration_aliases = [google]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.3"
    }
  }
}