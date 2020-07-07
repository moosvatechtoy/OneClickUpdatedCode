#
# Provider Configuration
#

provider "azurerm" {
#  version = "~>1.32.1"
   version = "~>2.0"
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
