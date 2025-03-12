#!/bin/bash

# Get cluster credentials and merge with local kubeconfig
echo "Getting AKS credentials..."
az aks get-credentials --resource-group $(terraform output -raw resource_group_name) --name $(terraform output -raw cluster_name) --overwrite-existing

# Verify connection
echo "Verifying connection to cluster..."
kubectl cluster-info

# Show available nodes
echo "Cluster nodes:"
kubectl get nodes

# Show available namespaces
echo "Cluster namespaces:"
kubectl get namespaces
