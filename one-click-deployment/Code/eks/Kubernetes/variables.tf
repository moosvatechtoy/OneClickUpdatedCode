#
# Variables Configuration
#

variable "access_key" {
  type    = string
  description = "Access key"
}

variable "secret_key" {
  type    = string
  description = "Secret key"
}

variable "cluster_name" {
#  default = "pk-terraform-eks"
  type    = string
  description = "Name of the eks cluster to be created"
}

variable "region_name" {
#  default  = "us-west-2"
  type    = string
  description = "Cluster to be created in which region ex: us-east-1" 
}

variable "vpc_cidr_block" {
#  default = "10.0.0.0/16"  
  type    = string
  description = "cidr block for vpc ex: 10.0.0.0/16"
}

variable "vpc_subnet" {
#  default = ["10.0.1.0/24", "10.0.2.0/24"]
  type = list(string)
  description = "VPC subnet ranges, minimum two should be entered. Ex: [\"10.0.1.0/24\", \"10.0.2.0/24\"] "
}

variable "instance_types" {
  type = list(string)
  description = "Instance type associated with the EKS Node Group Ex: [\"t3.medium\"]. Currently, the EKS API only accepts a single value in the set."
}

variable "desired_size" {
  type = number
  description = "Desired number of worker nodes. Should be grater than 0 "
}

variable "max_size" {
  type = number
  description = "Maximum number of worker nodes. Should be grater than 0 "
}

variable "min_size" {
  type = number
  description = "Minimum number of worker nodes. Should be grater than 0 "
}
