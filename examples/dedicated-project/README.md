# GCP Dedicated Project Onboarding Example

---

This is an example Terraform configuration that demonstrates how to create a dedicated Google Cloud Platform (GCP) project for Aqua Security resources using the dedicated_project module from the terraform-gcp-onboarding repository.

Overview
This example shows how to create a dedicated GCP project with a specific naming convention and apply the required labels for Aqua Security integration.

Prerequisites
Before running this example, ensure that you have the following:

Terraform installed (version 1.6.4 or later)
gcloud CLI installed and configured
Aqua Security account and API credentials (not required for this example)
Usage
Replace the placeholder values in the locals block with your actual values:
<org_name>: Your Google Cloud Organization name
<tenant_id>: Your Aqua Security tenant ID
<project_id>: The existing GCP project ID (root project)
Run terraform init to initialize the Terraform working directory.
Run terraform apply to create the dedicated project.
What's Happening
A dedicated GCP project is created with the name aqua-agentless-<tenant_id>-<org_hash>, where org_hash is the first six characters of the SHA1 hash of your organization name.
The labels input is set to merge custom labels (if provided) with the required "aqua-agentless-scanner" = "true" label.
Output
No specific output is defined in this example. However, you can access the following outputs from the dedicated_project module:

project_id: The ID of the created dedicated project.
project_name: The name of the created dedicated project.
project_number: The project number of the created dedicated project.
root_project_billing_account: The billing account associated with the root project.
Cleanup
To remove the dedicated project created by this example, run terraform destroy.