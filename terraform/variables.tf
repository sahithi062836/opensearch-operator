variable "resource_group_name" {
  description = "Name of the Azure resource group"
  default     = "my-aks-rg"
}

variable "location" {
  description = "Azure region for the resources"
  default     = "East US"
}

variable "aks_name" {
  description = "Name of the AKS cluster"
  default     = "my-aks-cluster"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  default     = 1
}

variable "node_vm_size" {
  description = "VM size for AKS nodes"
  default     = "Standard_DS2_v2"
}
