# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-cluster-${random_string.random.result}"
  #location = local.gcp_region
  location = var.gcp_location
  

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  min_master_version = local.kubernetes_version

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  master_auth {
    username = var.gke_username
    password = var.gke_password

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  #location = local.gcp_region
  location = var.gcp_location
  cluster    = google_container_cluster.primary.name
  initial_node_count = var.initial_node_count
  
    # Configuration required by cluster autoscaler to adjust the size of the node pool to the current cluster usage.
  autoscaling {
    # Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count.
    min_node_count = var.min_node_count

    # Maximum number of nodes in the NodePool. Must be >= min_node_count.
    max_node_count = var.max_node_count
  }

    # Node management configuration, wherein auto-repair and auto-upgrade is configured.
  management {
    # Whether the nodes will be automatically repaired.
    auto_repair = var.auto_repair

    # Whether the nodes will be automatically upgraded.
    auto_upgrade = var.auto_upgrade
  }

  node_config {

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }

    preemptible  = false
    
    service_account = google_service_account.service_account.email

    machine_type = var.machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

data "google_container_engine_versions" "location" {
  location = var.gcp_location
  project  = var.project_id
}

locals {
  latest_version     = data.google_container_engine_versions.location.latest_master_version
  kubernetes_version = var.kubernetes_version != "latest" ? var.kubernetes_version : local.latest_version
}

