# Cost-Effective AKS Cluster Terraform Configuration

This Terraform configuration deploys a minimal, cost-effective AKS cluster on Azure, following best practices for cost optimization.

## Cost-Saving Features

1. Uses `Standard_B2s` VM size (burstable, cost-effective)
2. Single node configuration
3. Disabled auto-scaling
4. Standard LRS disk type (cheaper than Premium)
5. Basic load balancer SKU
6. Kubenet networking (instead of Azure CNI)
7. Disabled unnecessary add-ons

## Prerequisites

1. Azure CLI installed and configured
2. Terraform installed
3. Azure subscription with sufficient permissions

## Usage

### Initial Setup

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Deploy the infrastructure:
   ```bash
   terraform plan
   terraform apply
   ```

### Cost Management Scripts

To minimize costs when the cluster is not in use, use the provided scripts:

1. Stop the cluster (to save costs):
   ```bash
   ./scripts/stop-cluster.sh
   ```

2. Start the cluster (when needed):
   ```bash
   ./scripts/start-cluster.sh
   ```

### Cleanup

To destroy all resources when no longer needed:
```bash
terraform destroy
```

## Estimated Costs

- VM (Standard_B2s): ~$30-40/month
- Managed Kubernetes: Free for basic cluster
- Storage: ~$5-10/month
- Network: Variable based on usage

Total estimated cost: $35-50/month when running continuously.
**Note**: Stop the cluster when not in use to minimize costs!
