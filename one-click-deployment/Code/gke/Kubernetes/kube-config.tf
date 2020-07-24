resource "null_resource" "config-temp" {
   # takes the back-up of config file if exists
  provisioner "local-exec" {
     command = "[ -f $HOME/.kube/config ] && mv $HOME/.kube/config $HOME/.kube/config_$(date +%F-%H:%M) || echo \"config file does not exist.\""
  } 

   # Activate the Service account
   provisioner "local-exec" {
        command = "gcloud auth activate-service-account --key-file=${var.credentials}"
  }

   # Copies the kubeconf file to ~/.kube/config
   provisioner "local-exec" {
        command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.gcp_location} --project ${var.project_id}"
  } 

  depends_on = [
     google_container_cluster.primary,
     google_container_node_pool.primary_nodes
  ]
}