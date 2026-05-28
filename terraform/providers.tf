terraform {
  required_providers {
    aws = {
      source = "aws"
      version = "5.100.0"
     }
  }
backend "s3" {
  bucket = "pjr-terraform-state270526"
  key = "ndt/terraform.tfstate"
  region = "eu-north-1"
  dynamodb_table = "Pjr-terraform-lock"
  encrypt = true
  }
}

provider "aws" {
  region = "eu-north-1"
  }

