terraform {
  required_version = ">= 1.5.0"
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "devops-tfstate-585980862780"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source           = "../../modules/vpc"
  project_name     = var.project_name
  vpc_cidr         = var.vpc_cidr
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  aws_region       = var.aws_region
}

module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
}

module "eks" {
  source           = "../../modules/eks"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids
  public_subnets   = module.vpc.public_subnet_ids
  eks_node_type    = var.eks_node_type
  eks_desired_size = var.eks_desired_size
  eks_min_size     = var.eks_min_size
  eks_max_size     = var.eks_max_size
}
