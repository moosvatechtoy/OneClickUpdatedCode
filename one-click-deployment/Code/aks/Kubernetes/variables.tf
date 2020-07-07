
variable "resource_group_name" {
  description = "Enter the exisitng resource group in which cluster will be created."
  type        = string
  #default     = "aksdemorg"
}

variable "availability_zones" {
  description = "A list of AZs across which the Node Pool should be spread. Ex: [\"1\", \"2\", \"3\"]"
  type        = list(string)
  #default     = ["1", "2", "3"]
  #default    = []
}

#variable "location" {
#    description = "Location in which resource group, cluster and log analytics are created. Ex: East US 'or' North Europe"
#    type = string
#    default = "Central US"
#}

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
  #default = 4
}

variable "agent_vm_size" {
  description = "The size of the Virtual Machine, such as Standard_DS2_v2"
  type    = string
  #default = "Standard_B2s"
  #default  = "Standard_D2s_v3"
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

variable "subscription_id" {
  description = "Please specify subscription_id."
  type        = string
}

variable "tenant_id" {
  description = "Please specify tenant_id."
  type        = string
}

# Azure Credentials - END

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

#variable for advanced networking

variable "network_plugin" {
  default     = "azure"
  description = "Network plugin used by AKS. Either azure or kubenet."
}
variable "network_policy" {
  default     = "azure"
  description = "Network policy to be used with Azure CNI. Either azure or calico."
}

variable "service_cidr" {
  default     = "10.0.0.0/16"
  description = "Used to assign internal services in the AKS cluster an IP address. This IP address range should be an address space that isn't in use elsewhere in your network environment. This includes any on-premises network ranges if you connect, or plan to connect, your Azure virtual networks using Express Route or a Site-to-Site VPN connections."
  type        = string
}

variable "dns_ip" {
  default     = "10.0.0.10"
  description = "should be the .10 address of your service IP address range"
  type        = string
}

variable "docker_cidr" {
  default     = "172.17.0.1/16"
  description = "IP address (in CIDR notation) used as the Docker bridge IP address on nodes. Default of 172.17.0.1/16."
}

