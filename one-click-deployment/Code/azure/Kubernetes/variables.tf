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

variable "prefix" {
  description = "To set the prefix for all the variables created."
  #default = "tfdemo"
}

variable "resource_group_name" {
  description = "Enter the exisitng resource group in which cluster will be created."
  type        = string
  #default     = "newtesting"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. Ex: 10.10.0.0/16"
  #default     = "10.10.0.0/16"
}


variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet. Ex: [\"10.10.1.0/24\"]"
  type = list(string)
  #default     = ["10.10.1.0/24"]
}

variable "vm_count" {
  description = "Number of VMs to create"
  type = number
  #default = 2
}

variable "vm_size" {
  description = "The size of the Virtual Machine, such as Standard_DS2_v2"
  type    = string
  #default = "Standard_B1s"
  #default  = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  description = "The disk size of the Virtual Machine in GB ex: 30"
  type    = number
  #default = 30
}

variable "admin_user" {
  description = "The Admin Username for the Cluster. Changing this forces a new resource to be created."
  type    = string
  #default = "azureuser"
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure"
  #default     = "Temppass@123"
}

variable "ssh_public_key" {
  description = "The ssh_public_key is the RSA public key that was created for VM access."
  type = string
  #default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCliwowew8VX22ugb0DdUbUr28YxykjcjJNZpSx4MFVTRN93TliBkA/6hO82xpSaHzy90uFtVqCWsPD3aIiL/TpElEUh/5bqu3lT1fdqICoZVPmd1rk+oWqhBa0u8JsxqxwOXJV4jb0+H+w+O7DUvcXnOqz0URK2geshsFjqTt8UIhqq10bw6/14bajDmc257+eWTaYCtZzkHYZl0YzLDJ+nbvbS19IyEDZmVA4HKZ1QY7dLs3DXgbBMkw88x9OTokQd6ayEeJ1rt14leCgVHcvLtC5QGLRUQstX7BKQRAPb8R7TC/BSfn2m8WwBmLNXyUcLFxw9MNu7dZZlnH7p/P1 sasidhar@LAPTOP-B5UETTM7"
}


#variable "availability_zones" {
#  description = "A list of AZs across which the Node Pool should be spread. Ex: [\"1\", \"2\", \"3\"]"
#  type        = list(string)
#  default     = ["1", "2", "3"]
#  #default    = []
#}

#variable "location" {
#    description = "Location in which resource group, cluster and log analytics are created. Ex: East US 'or' North Europe"
#    type = string
#    default = "Central US"
#}