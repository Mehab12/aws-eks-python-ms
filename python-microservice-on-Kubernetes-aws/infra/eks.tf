module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name    = var.cluster_name
  cluster_version = var.eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["176.202.102.160/32"] #my ip for testing
  enable_cluster_creator_admin_permissions = true
  eks_managed_node_groups = {
    main = {
      name = var.node_group_name

      instance_types = [var.node_instance_type]
      min_size       = var.node_min_capacity
      max_size       = var.node_max_capacity
      desired_size   = var.node_desired_capacity
    }
  }
}

