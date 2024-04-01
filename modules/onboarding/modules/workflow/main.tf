# modules/onboarding/modules/workflow/main.tf

# Creating google workflow
resource "google_workflows_workflow" "workflows_workflow" {
  name            = var.workflow_name
  project         = var.project_id
  region          = var.region
  service_account = var.service_account_email
  source_contents = <<-EOF
  main:
    params: [input]
    steps:
      - get_message:
          try:
            call: http.post
            args:
              url: ${var.aqua_volscan_api_url}
              headers:
                X-Pub-Api-Key: ${var.aqua_volscan_api_token}
              body: $${input.data.message.data}
            result: output
          retry:
            max_retries: 6
            backoff:
              initial_delay: 60
              max_delay: 300
              multiplier: 2
      - return_value:
          return: $${output.body}
EOF
}
