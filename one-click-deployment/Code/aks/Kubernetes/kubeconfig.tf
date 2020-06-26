resource "local_file" "cluster_credentials" {
  #count             = var.kubeconfig_to_disk ? 1 : 0
  sensitive_content = azurerm_kubernetes_cluster.cluster.kube_config_raw
  filename = "./config"

  depends_on = [azurerm_kubernetes_cluster.cluster]
}

resource "null_resource" "config-temp" {
 
   # Copies the kubeconf file to ~/.kube/config
   provisioner "local-exec" {
     command = "[ -f /$HOME/.kube/config ] && mv /$HOME/.kube/config /$HOME/.kube/config_$(date +%F-%H:%M) || echo \"config file does not exist.\""
  } 
   provisioner "local-exec" {
     command = "[ -d /$HOME/.kube/ ] && echo \".kube dir exists.\" || mkdir ~/.kube"
  }
   provisioner "local-exec" {
     command = "mv ./config ~/.kube/config"
 }
  depends_on = [
     local_file.cluster_credentials
  ]
}