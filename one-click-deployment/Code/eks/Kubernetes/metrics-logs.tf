
resource "null_resource" "container-insight" {
  provisioner "local-exec" {
    #command = "kubectl apply -f -<<EOF\n${data.template_file.metrics.rendered}\nEOF"
    command = "curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluentd-quickstart.yaml | sed \"s/{{cluster_name}}/${aws_eks_cluster.setup_step.id}/\" | sed \"s/{{region_name}}/${data.aws_region.current.id}/\" | kubectl apply -f -"
  }
  depends_on = [
    null_resource.config-temp
  ]
}

resource "null_resource" "cluster-autoscaler" {
  provisioner "local-exec" {
    #command = "kubectl apply -f -<<EOF\n${data.template_file.metrics.rendered}\nEOF"
    command = "curl https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml | sed \"s/<YOUR CLUSTER NAME>/${aws_eks_cluster.setup_step.id}/\" | kubectl apply -f -"
  }
  depends_on = [
    null_resource.container-insight
  ]
}
