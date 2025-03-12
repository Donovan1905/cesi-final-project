# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "cesi-final-project"
  location = "East US"  # Choose the closest region to reduce latency
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "minimal-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "minimalaks"
  kubernetes_version  = "1.28.3"  # Latest stable version

  sku_tier = "Free"

  default_node_pool {
    name                = "default"
    node_count          = 1
    vm_size            = "Standard_B2s"  # Cheapest viable option
    enable_auto_scaling = false
    
    # Use cheaper managed disks
    os_disk_size_gb    = 30
    # os_disk_type       = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  # Minimize costs with network profile
  network_profile {
    network_plugin    = "kubenet"  # Use kubenet instead of azure-cni
    load_balancer_sku = "basic"    # Use basic load balancer
  }

  # Disable all non-essential addons
  azure_policy_enabled = false
  http_application_routing_enabled = false

  tags = {
    Environment = "Development"
  }
}

# Outputs for cluster connection
output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
  description = "The name of the AKS cluster"
}

output "resource_group_name" {
  value = azurerm_resource_group.aks_rg.name
  description = "The name of the resource group"
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
  description = "The kubeconfig for connecting to the cluster"
}

output "cluster_host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
  description = "The URL for the Kubernetes API server"
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
  description = "The client certificate for authentication"
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive = true
  description = "The client key for authentication"
}
