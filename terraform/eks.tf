module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.resource_prefix}EKS"
  kubernetes_version = var.eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {}
  }

  eks_managed_node_groups = {
    "${var.resource_prefix}NodeGroup" = {
      name = "${var.resource_prefix}NodeGroup"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      subnet_ids = module.vpc.private_subnets

      tags = {
        Name        = "${var.resource_prefix}NodeGroup"
        Environment = var.resource_prefix
        Project     = "WizExercise"
      }
    }
  }

  tags = {
    Name        = "${var.resource_prefix}EKS"
    Environment = var.resource_prefix
    Project     = "WizExercise"
  }
}