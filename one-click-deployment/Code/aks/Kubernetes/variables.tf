
variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
  type        = string
  #default     = "aksdemorg"
}

variable "cluster_name" {
  description = "The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
  #default     = "pk-demo"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. Ex: 10.10.0.0/16"
  #default     = "10.10.0.0/16"
}


variable "initial_vm_count" {
  description = "Please specify initial number of worker nodes for AKS Cluster."
  type    = number
  #default = 1
}

variable "min_vm_count" {
  description = "Please specify minimum number of worker nodes for AKS Cluster."
  type    = number
  #default = 1
}

variable "max_vm_count" {
  description = "Please specify maximum number of worker nodes for AKS Cluster."
  type    = number
  #default = 3
}

variable "agent_vm_size" {
  description = "The size of the Virtual Machine, such as Standard_DS1_v2"
  type    = string
  #default = "Standard_DS1_v2"
}

variable "os_disk_size_gb" {
  description = "The disk size of the Virtual Machine in GB ex: 30"
  type    = number
  #default = 30
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet. Ex: [\"10.10.1.0/24\", \"10.10.2.0/24\"]"
  type = list(string)
  #default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "ssh_public_key" {
  description = "The ssh_public_key is the RSA public key that was created for AKS node access."
  type = string
  #default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCliwowew8VX22ugb0DdUbUr28YxykjcjJNZpSx4MFVTRN93TliBkA/6hO82xpSaHzy90uFtVqCWsPD3aIiL/TpElEUh/5bqu3lT1fdqICoZVPmd1rk+oWqhBa0u8JsxqxwOXJV4jb0+H+w+O7DUvcXnOqz0URK2geshsFjqTt8UIhqq10bw6/14bajDmc257+eWTaYCtZzkHYZl0YzLDJ+nbvbS19IyEDZmVA4HKZ1QY7dLs3DXgbBMkw88x9OTokQd6ayEeJ1rt14leCgVHcvLtC5QGLRUQstX7BKQRAPb8R7TC/BSfn2m8WwBmLNXyUcLFxw9MNu7dZZlnH7p/P1 sasidhar@LAPTOP-B5UETTM7"
}

# Azure Credentials

variable "client_id" {
  description = "Please specify client_id (service_principal_id)."
  type        = string
}

variable "client_secret" {
  description = "Please specify client_secret (service_principal_secret)."
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster. It must start with a letter and must end with a letter or a number."
  type        = string
  default     = "aks-prefix"
}

variable "admin_user" {
  description = "The Admin Username for the Cluster. Changing this forces a new resource to be created."
  type    = string
  default = "k8sadmin"
}

variable "solution_name" {
  description = "The name of the solution to be deployed."
  default     = "ContainerInsights"
}

variable "worker_nodes_os_type" {
  description = "Specify OS Type for worker nodes."
  default = "Linux"
}

variable "oms_agent_enabled" {
  default     = "true"
  description = "Enable Azure Monitoring for AKS"
  type        = string
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

#variable "subnet_service_endpoints" {
#  description = "A list of the service endpoints for the subnet (e.g. Microsoft.Web)"
#  type        = list
#  default     = [[], []]
#}

#variable "tags" {
#  description = "The tags to associate with your network and subnets."
#  type        = map
#  default = {
#    tag1 = "tag1"
#    tag2 = "tag2"
#  }
#}


