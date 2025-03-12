#!/bin/bash

# Exit on any error
set -e

# Change to the terraform directory
cd "$(dirname "$0")"/.. || exit

# Check if terraform state exists
if [ ! -f "terraform.tfstate" ]; then
    echo "Error: terraform.tfstate not found. Please run 'terraform apply' first."
    exit 1
fi

# Get cluster name and resource group
echo "Getting cluster information from Terraform state..."
CLUSTER_NAME=$(terraform output -raw cluster_name)
RESOURCE_GROUP=$(terraform output -raw resource_group_name)

# Check if variables are empty
if [ -z "$CLUSTER_NAME" ] || [ -z "$RESOURCE_GROUP" ]; then
    echo "Error: Could not get cluster information from Terraform state."
    echo "Please ensure you have run 'terraform apply' and the cluster exists."
    exit 1
fi

echo "Stopping AKS cluster: $CLUSTER_NAME in resource group: $RESOURCE_GROUP"

# Check if cluster exists
if ! az aks show --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP" >/dev/null 2>&1; then
    echo "Error: Cluster $CLUSTER_NAME not found in resource group $RESOURCE_GROUP"
    exit 1
fi

# Stop the AKS cluster
echo "Stopping AKS cluster..."
az aks stop --name "$CLUSTER_NAME" --resource-group "$RESOURCE_GROUP"

# Get the node resource group
NODE_RG=$(az aks show --resource-group "$RESOURCE_GROUP" --name "$CLUSTER_NAME" --query nodeResourceGroup -o tsv)

# Check if there are any VMs to stop
VM_IDS=$(az vm list -g "$NODE_RG" --query "[].id" -o tsv)
if [ -n "$VM_IDS" ]; then
    echo "Stopping VMs in node resource group: $NODE_RG"
    az vm stop --ids $VM_IDS
    echo "All VMs stopped successfully"
else
    echo "No VMs found in node resource group: $NODE_RG"
fi

echo "Cluster shutdown completed successfully"
