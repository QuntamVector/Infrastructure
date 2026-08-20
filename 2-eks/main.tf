locals {
  vpc_id             = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_ids  = data.terraform_remote_state.network.outputs.public_subnet_ids
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  # EKS Cluster
  name               = var.project
  kubernetes_version = var.kubernetes_version

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  # Enable IAM Roles for Service Accounts (IRSA)
  enable_irsa = true

  # Cluster Endpoint Access
  endpoint_public_access  = true
  endpoint_private_access = true

  # Give the IAM identity running Terraform admin access to the cluster
  enable_cluster_creator_admin_permissions = true

  # Managed Node Group(s)
  eks_managed_node_groups = {
    default = {
      name           = "${var.project}-ng"
      instance_types = ["t3.medium"]

      min_size     = 3
      max_size     = 5
      desired_size = 3

      subnet_ids = local.private_subnet_ids

      # Disable custom launch template so remote_access can be used
      use_custom_launch_template = false

      # SSH access to worker nodes
      remote_access = {
        ec2_ssh_key               = var.ssh_key_name
        source_security_group_ids = []
      }
    }
  }

  # Common Tags
  tags = {
    Project = var.project
  }
}

