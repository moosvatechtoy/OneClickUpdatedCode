
locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
}

provider "google" {
  credentials = var.credentials
  project = var.project_id
  region  = local.gcp_region
}

resource "random_string" "random" {
  length = 5
  special = false
  upper = false
  number = false
}

#terraform {
#  backend "gcs" { }
#}
