#
# Provider Configuration
#

provider "azurerm" {
#  version = "~>1.32.1"
   version = "~>2.0"
   subscription_id = var.subscription_id
   client_id       = var.client_id
   client_secret   = var.client_secret
   tenant_id       = var.tenant_id
   features {}
}

# Needed for the traffic manager role assignment
provider "azuread" {
  version = "~>0.5.1"
}

provider "null" {
  version = "~>2.1.2"
}

provider "random" {
  version = "~> 2.1"
}

terraform {
  required_version = "~> 0.12.6"
}

#terraform {
#  backend "azurerm" { }
#}
