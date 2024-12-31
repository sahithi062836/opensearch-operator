# Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "aks-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for AKS Cluster
resource "azurerm_subnet" "example" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# AKS Cluster with Autoscaling Enabled
resource "azurerm_kubernetes_cluster" "example" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_vm_size
    vnet_subnet_id = azurerm_subnet.example.id

    # Enable Autoscaling on the Node Pool
    enable_auto_scaling = var.enable_autoscaler
    min_count           = var.min_node_count
    max_count           = var.max_node_count
  }

  identity {
    type = "SystemAssigned"
  }

  # Network Profile with a non-overlapping Service CIDR
  network_profile {
    network_plugin   = "azure"
    service_cidr     = "10.1.0.0/16"  # Change this to a non-overlapping CIDR
    dns_service_ip   = "10.1.0.10"    # Ensure the DNS IP is within the service CIDR range
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = {
    environment = "dev"
  }
}
