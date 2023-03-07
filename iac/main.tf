resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  
  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false

  }

  identity {
    type = "SystemAssigned"
  }
  
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" 
    network_policy = "calico"
  }

  role_based_access_control {    
    enabled = true
  }
}


provider "kubernetes" {
  host                   = "${resource.azurerm_kubernetes_cluster.aks.kube_config.0.host}"
  client_certificate     = "${base64decode(resource.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(resource.azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(resource.azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}
