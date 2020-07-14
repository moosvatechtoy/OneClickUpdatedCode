# Vnet

data "azurerm_resource_group" "testrg" {
  name = var.resource_group_name
}

resource "random_id" "workspace" {
  keepers = {
    group_name = data.azurerm_resource_group.testrg.name
    location   = data.azurerm_resource_group.testrg.location
  }
  byte_length = 8
}

resource "random_string" "random" {
  length = 4
  special = false
  upper = false
  number = false
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.testrg.name
  location            = data.azurerm_resource_group.testrg.location
  address_space       = [var.address_space]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.testrg.name
  address_prefixes    = var.subnet_prefixes
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  resource_group_name = data.azurerm_resource_group.testrg.name
  location            = data.azurerm_resource_group.testrg.location

  security_rule {
      name                       = "SSH_VNET"
      priority                   = 4000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      #source_address_prefix      = "VirtualNetwork"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
  }

  security_rule {
      name                       = "HTTP_VNET"
      priority                   = 1000
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "10.10.0.0/16" // replace with ASG later
      destination_address_prefix = "*"
  }
  tags = {
    environment = "test"
  }
}

# Create Application Security Group
resource "azurerm_application_security_group" "asg" {
  name                = "${var.prefix}-asg-${random_string.random.result}"
  resource_group_name       = data.azurerm_resource_group.testrg.name
  location                  = data.azurerm_resource_group.testrg.location
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  count                     = var.vm_count
  name                      = "${var.prefix}-nic-${count.index + 1}"
  resource_group_name       = data.azurerm_resource_group.testrg.name
  location                  = data.azurerm_resource_group.testrg.location

  ip_configuration {
    name                          = "${var.prefix}-nic-conf-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "nsga" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_application_security_group_association" "asga" {
  count                         = var.vm_count
  network_interface_id          = azurerm_network_interface.nic[count.index].id
  application_security_group_id = azurerm_application_security_group.asg.id
}

resource "azurerm_availability_set" "avset" {
  name                        = "${var.prefix}-avset"
  resource_group_name         = data.azurerm_resource_group.testrg.name
  location                    = data.azurerm_resource_group.testrg.location
  managed                     = "true"
  platform_fault_domain_count = 2  # default 3 cannot be used
  
  tags = {
    environment = "test"
  }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.workspace.hex}"
    resource_group_name         = data.azurerm_resource_group.testrg.name
    location                    = data.azurerm_resource_group.testrg.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "test"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.prefix}-vm-${count.index + 1}"
  resource_group_name   = data.azurerm_resource_group.testrg.name
  location              = data.azurerm_resource_group.testrg.location
  #network_interface_ids = ["${azurerm_network_interface.nic.*.id[count.index]}"]
  network_interface_ids = ["${azurerm_network_interface.nic[count.index].id}"]
  vm_size               = var.vm_size
  availability_set_id   = azurerm_availability_set.avset.id

  storage_os_disk {
    name              = "${format("%s-app-%03d-osdisk", var.prefix, count.index + 1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"

    disk_size_gb      = var.os_disk_size_gb # increase default os disk
  }

  /*
    # add extra data disk
    storage_data_disk {
        name              = "${format("%s-app-%03d-datadisk", var.resource_group_name, count.index + 1)}"
        managed_disk_type = "Premium_LRS"
        create_option     = "Empty"
        lun               = 0
        disk_size_gb      = "128"        
    }
  */

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }
  
  os_profile {
      computer_name  = "${format("testvm%03d", count.index + 1)}"
      admin_username = var.admin_user
      admin_password = var.admin_password
  }

  os_profile_linux_config {
      disable_password_authentication = false
      ssh_keys {
          path     = "/home/${var.admin_user}/.ssh/authorized_keys"
          key_data = var.ssh_public_key
      }
  }
  boot_diagnostics {
      enabled = "true"
      storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
  }
  tags = {
    environment = "test"
  }
}

resource "azurerm_public_ip" "pip" {
  count                = var.vm_count
  name                 = "${var.prefix}-pip-${count.index + 1}"
  resource_group_name  = data.azurerm_resource_group.testrg.name
  location             = data.azurerm_resource_group.testrg.location
  allocation_method    = "Dynamic"
  sku                  = "Basic"

  tags = {
      environment = "test"
  }
}