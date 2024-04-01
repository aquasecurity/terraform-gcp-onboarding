# GCP Same Project Onboarding Example

---

## Overview

This example shows how to onboard a Google Cloud Platform (GCP) project by provisioning all of Aqua’s resources into the existing project.

## Prerequisites

Before running this example, ensure that you have the following:

1. Terraform installed (version 1.6.4 or later).
2. `gcloud` CLI installed and configured.
3. Aqua Security account and API credentials.

## Usage

1. Replace the placeholder values in the `locals` block with your actual values.
2. Run `terraform init` to initialize the Terraform working directory.
3. Run `terraform apply` to create the resources.

## What's Happening

1. The `aqua_gcp_onboarding` module is called to provision the necessary resources (service accounts, roles, networking, etc.) in the existing GCP project.
2. The `aqua_gcp_project_attachment` module is called to create the required IAM resources in the onboarding project and trigger the Aqua API.


## Cleanup

To remove the resources created by this example, run `terraform destroy`.