module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "ndt-vpc"
  cidr = "10.0.0.0/16"

  azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  
  cluster_name = "ndt-cluster"
  cluster_version = "1.33"

  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    worker_nodes = {
      min_size = 2
      max_size = 5
      desired_size = 2
      capacity_type = "SPOT"
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 24
            volume_type = "gp3"
            delete_on_termination = false
        }
       }
      }
      instance_types = ["t3.medium", "t3.small", "t3a.medium", "t2.medium"] 
     }
   }
  enable_cluster_creator_admin_permissions = true
}
