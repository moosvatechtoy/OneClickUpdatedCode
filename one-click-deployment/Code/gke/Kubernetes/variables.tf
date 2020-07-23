
variable "credentials" {
  description = "Absolute path to key file in JSON format. Ex: /home/user/azurekey/project-123.json (without Quotes)"
  type        = string
}

variable "project_id" {
  type = string

  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "vpc_subnetwork_cidr_range" {
  description = "The IP address range of the VPC in CIDR notation. Ex: 10.0.0.0/16. A prefix of /16 is recommended. Do not use a prefix higher than /27."
  type        = string
}

variable "gcp_location" {
  type = string

  description = <<EOF
--> The location (region or zone) in which the cluster master will be created, as well as the default node location. 
If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with single cluster master. 
If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in that region.
--> Node pools will also be created as regional or zonal accordingly.
If a node pool is zonal it will have nodes in that zone. 
If a node pool is regional it will have nodes in each zone within that region. 
For more information see: https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters
EOF
}

variable "initial_node_count" {
  type = number
  description = "Number of initial nodes to create"
}

variable "min_node_count" {
  type = number
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
}

variable "max_node_count" {
  type = number
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
}

variable "machine_type" {
  type = string
  description = "Type of machine for nodes- Ex: n1-standard-1."
}

variable "auto_repair" {
  default = true
  description = "Whether the nodes will be automatically repaired."
}

variable "auto_upgrade" {
  default = true
  description = "Whether the nodes will be automatically upgraded."
}

variable "description" {
  description = "The description of the custom service account."
  type        = string
  default     = "Service account with minimum necessary roles and permissions in order to run the GKE cluster"
}

variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = []
}

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "cluster_secondary_range_name" {
  type = string
  default = "secondary-range-pod-ip"
  description = <<EOF
The name of the secondary range to be used as for the cluster CIDR block.
This must be an existing secondary range associated with the cluster subnetwork.
EOF
}

variable "cluster_secondary_range_cidr" {
  type = string
  description = <<EOF
This secondary range will be used for pod IP addresses. 
This must be an existing secondary range associated with the cluster subnetwork.
Ex: 10.10.0.0/18
EOF
}

variable "services_secondary_range_name" {
  type = string
  default = "secondary-range-service-ip"
  description = <<EOF
The name of the secondary range to be used as for the services CIDR block.
This must be an existing secondary range associated with the cluster subnetwork.
EOF
}

variable "services_secondary_range_cidr" {
  type = string
  description = <<EOF
This secondary range will be used for service ClusterIPs. 
This must be an existing secondary range associated with the cluster subnetwork.
Ex: 10.20.0.0/20
EOF
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  type        = string
  default     = "latest"
}