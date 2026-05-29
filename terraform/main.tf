module "ECR_repo" {
  source = "./modules/ecr"
  }

module "EKS_code" {
  source = "./modules/eks"
  }

module "LBC_IRSA" {
  source = "./modules/iam"
  oidc_provider_arn = module.EKS_code.oidc_provider_arn
  }
