# GCP Dedicated Project Onboarding Example

---

This is an example Terraform configuration that demonstrates how to create a dedicated Google Cloud Platform (GCP) project for Aqua Security resources using the `dedicated_project` module from the `terraform-gcp-onboarding` repository.

## Overview

This example shows how to create a dedicated GCP project with a specific naming convention and apply the required labels for Aqua Security integration.

## Prerequisites

Before running this example, ensure that you have the following:

1. Terraform installed (version 1.6.4 or later).
2. `gcloud` CLI installed and configured.
3. Aqua Security account and API credentials (not required for this example).

## Usage

1. Replace the placeholder values in the `locals` block with your actual values.
2. Run `terraform init` to initialize the Terraform working directory.
3. Run `terraform apply` to create the dedicated project.

## What's Happening

1. A dedicated GCP project is created with the name `aqua-agentless-<tenant_id>-<org_hash>`, where `org_hash` is the first six characters of the SHA1 hash of your organization name.
2. The `labels` input is set to merge custom labels (if provided) with the required `"aqua-agentless-scanner" = "true"` label.

## Cleanup

To remove the dedicated project created by this example, run `terraform destroy`.