

# Vnet

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
  number = false
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_group_name}-vpc-${random_string.random.result}"
  location            = data.azurerm_resource_group.cluster.location
  address_space       = [var.address_space]
  resource_group_name = data.azurerm_resource_group.cluster.name
  #dns_servers         = var.dns_servers
  #tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_prefixes)
  name                 = "${azurerm_virtual_network.vnet.name}-subnet-${count.index + 1}"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.cluster.name

  address_prefixes    = [var.subnet_prefixes[count.index]]
  #address_prefix    = var.subnet_prefixes[count.index]

  #service_endpoints = var.subnet_service_endpoints[count.index]
}