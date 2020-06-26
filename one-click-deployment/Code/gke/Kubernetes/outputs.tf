output "region" {
  value       = local.gcp_region
  description = "region in which cluster created"
}

output "location" {
  value       = var.gcp_location
  description = "region or zone in which cluster created"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}