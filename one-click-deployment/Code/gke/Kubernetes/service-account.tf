# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.7"
}

# Use this datasource to access the Terraform account's email for Kubernetes permissions.
data "google_client_openid_userinfo" "terraform_user" {}

# ----------------------------------------------------------------------------------------------------------------------
# CREATE SERVICE ACCOUNT
# ----------------------------------------------------------------------------------------------------------------------
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "${var.project_id}-sa-${random_string.random.result}"
  display_name = var.description
}

# ----------------------------------------------------------------------------------------------------------------------
# ADD ROLES TO SERVICE ACCOUNT
# Grant the service account the minimum necessary roles and permissions in order to run the GKE cluster
# plus any other roles added through the 'service_account_roles' variable
# ----------------------------------------------------------------------------------------------------------------------
locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "service_account-roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.service_account.email}"
}