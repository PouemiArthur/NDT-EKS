module "ECR_repo" {
  source = "./modules/ecr"
  }

module "EKS_code" {
  source = "./modules/eks"
  }

module "EBS_CSIIAM" {
  source = "./modules/ebscsiiam"
  }
