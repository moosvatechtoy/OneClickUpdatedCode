
# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc-${random_string.random.result}"
  auto_create_subnetworks = "false"
  project                 = var.project_id
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet-${random_string.random.result}"
  region        = local.gcp_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.vpc_subnetwork_cidr_range

  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }
  depends_on = [
    google_compute_network.vpc,
  ]
}
