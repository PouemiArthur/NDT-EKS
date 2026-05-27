module "S3_DDB" {
  source = "./modules/state-lock"
  }

module "ECR_repo" {
  source = "./modules/ecr"
  }

module "EKS_code" {
  source = "./modules/eks"
  }

