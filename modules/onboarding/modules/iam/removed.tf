# The project_iam_member_* resources replace these authoritative bindings. Dropping them from state
# without destroying keeps an upgrade from clearing the role members the new resources just added.

removed {
  from = google_project_iam_binding.project_iam_binding_pubsub

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_workflows

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_eventarc

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_service_account_user

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_container

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_create_role

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_delete_role

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_eventarc_eventReceiver

  lifecycle {
    destroy = false
  }
}

removed {
  from = google_project_iam_binding.project_iam_binding_workflows_invoker

  lifecycle {
    destroy = false
  }
}
