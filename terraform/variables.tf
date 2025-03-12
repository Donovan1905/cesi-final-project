variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "aks-resource-group"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "minimal-aks-cluster"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}
