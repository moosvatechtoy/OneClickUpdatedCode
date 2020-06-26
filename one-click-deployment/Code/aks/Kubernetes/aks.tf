
data "azurerm_resource_group" "cluster" {
  name = var.resource_group_name
}

resource "random_id" "workspace" {
  keepers = {
    group_name = data.azurerm_resource_group.cluster.name
    location   = data.azurerm_resource_group.cluster.location
  }
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${data.azurerm_resource_group.cluster.name}-log-workspace-${random_id.workspace.hex}"
  location            = data.azurerm_resource_group.cluster.location
  resource_group_name = data.azurerm_resource_group.cluster.name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "solution" {
  solution_name         = var.solution_name
  location              = data.azurerm_resource_group.cluster.location
  resource_group_name   = data.azurerm_resource_group.cluster.name
  workspace_resource_id = azurerm_log_analytics_workspace.workspace.id
  workspace_name        = azurerm_log_analytics_workspace.workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.cluster.location
  resource_group_name = data.azurerm_resource_group.cluster.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = var.admin_user

    ssh_key {
      key_data = replace(var.ssh_public_key, "\n", "")
    }
  }

  agent_pool_profile {
    name            = "default"
    enable_auto_scaling = true
    count           = var.initial_vm_count
    min_count       = var.min_vm_count
    max_count       = var.max_vm_count
    vm_size         = var.agent_vm_size
    os_type         = var.worker_nodes_os_type
    os_disk_size_gb = 30
    #vnet_subnet_id  = azurerm_subnet.subnet.0.id
    type            = "VirtualMachineScaleSets"
  }

  role_based_access_control {
    enabled = true
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  addon_profile {
    oms_agent {
      enabled                    = var.oms_agent_enabled
      log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
    }
  }
}