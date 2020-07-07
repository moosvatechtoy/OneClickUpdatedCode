output "client_key" {
    sensitive = true
    value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_key
}

output "cluster_ca_certificate" {
    sensitive = true
    value = azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate
}

output "cluster_username" {
    value = azurerm_kubernetes_cluster.cluster.kube_config.0.username
}

output "cluster_password" {
    sensitive = true
    value = azurerm_kubernetes_cluster.cluster.kube_config.0.password
}

output "host" {
    value = azurerm_kubernetes_cluster.cluster.kube_config.0.host
}

output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
}