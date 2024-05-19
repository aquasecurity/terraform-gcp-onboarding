# Onboarding an Organization with Infrastructure on a Dedicated Project Example

---

## Overview

This example demonstrates how to onboard a Google Cloud Platform (GCP) organization for Aqua Security integration by creating a dedicated project and provisioning all Aqua's resources within it.

## Pre-requisites

Before running this example, ensure that you have the following:

1. Terraform installed (version 1.6.4 or later).
2. `gcloud` CLI installed and configured.
3. Aqua Security account API credentials.
4. Appropriate permissions to manage resources at the organization level and within the specified projects.

## Usage

1. Obtain the Terraform configuration file generated by the Aqua platform.
2. Important: Replace `<aqua_api_key>` and `<aqua_api_secret>` with your generated API credentials.
3. Run `terraform init` to initialize the Terraform working directory.
4. Run `terraform apply` to create the resources.

## Providing Project ID List

You can provide your own list of project IDs by populating the `projects_list` local. To accommodate this, ensure to remove the `data "google_projects"` and then replace the local `projects_list` with your list.

```hcl
locals {
  projects_list = [
    "my-project-id-1",
    "my-project-id-2",
    // Add more project IDs as needed
  ]
}
```

## What's Happening

1. The `aqua_gcp_dedicated_project` module is called to create a dedicated GCP project with the name `aqua-agentless-<tenant_id>-<org_hash>`, where `org_hash` is the first six characters of the SHA1 hash of your organization name.
2. The `aqua_gcp_onboarding` module is called to provision the necessary resources (service accounts, roles, networking, etc.) in the dedicated GCP project.
3. The `aqua_gcp_project_attachment` module is called for each GCP project in the organization to create the required IAM resources and trigger the Aqua API to onboard the project.

## Outputs

- `onboarding_status`: This output displays the result of the onboarding process for each project, indicating whether it was successful or encountered any errors.

## Cleanup

To remove the resources created by this example, including the organization-level resources, dedicated project, and attached projects, run `terraform destroy`.
