
# Define an config file containing Terraform variable values
data "template_file" "config-temp" {
  template = "${file("./config-temp")}"
  vars = {
    server = aws_eks_cluster.setup_step.endpoint
    certificate-authority-data = aws_eks_cluster.setup_step.certificate_authority.0.data
    cluster_name = var.cluster_name
  }
    depends_on = [
     aws_eks_cluster.setup_step,
     aws_eks_node_group.setup_step
  ]
}
 
# Render the config-temp file containing Terrarorm variable values
resource "local_file" "config-temp" {
  content  = data.template_file.config-temp.rendered
  filename = "./config"
}
resource "null_resource" "config-temp" {
 
   # Copies the kubeconf file to ~/.kube/config
   provisioner "local-exec" {
     #command = "rm -rf ~/.kube/"
     command = "[ -f /$HOME/.kube/config ] && mv /$HOME/.kube/config /$HOME/.kube/config_$(date +%F-%H:%M) || echo \"config file does not exist.\""
  } 
   provisioner "local-exec" {
     #command = "mkdir ~/.kube"
     command = "[ -d /$HOME/.kube/ ] && echo \".kube dir exists.\" || mkdir ~/.kube"
  }
   provisioner "local-exec" {
     command = "mv ./config ~/.kube/config"
 }
  depends_on = [
     local_file.config-temp
  ]
}