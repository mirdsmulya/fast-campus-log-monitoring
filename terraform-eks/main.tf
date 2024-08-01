module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "fast-campus-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = "vpc-00feacb6d220c5212"
  subnet_ids               = ["subnet-0b1e99ef139f6ce5c", "subnet-01230307ad1145140", "subnet-0eb072d20a5aeb00b"]
  control_plane_subnet_ids = ["subnet-0b1e99ef139f6ce5c", "subnet-01230307ad1145140", "subnet-0eb072d20a5aeb00b"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    fast-campus = {
      min_size     = 4
      max_size     = 10
      desired_size = 4

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    example = {
      kubernetes_groups = ["masters"]
      principal_arn     = "arn:aws:iam::675327529402:role/eks-role"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["*"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Environment = "staging"
    Terraform   = "true"
  }
}