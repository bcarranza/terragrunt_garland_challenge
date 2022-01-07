locals {
  aws_region       = var.aws_region
  environment_name = var.environment
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform.old.format/aws/${local.environment_name}/10-vpc",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    organization = "managedkube1"

    workspaces {
      name = "vpc_workspace_${local.environment_name}"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# VPC
#
module "vpc" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/vpc?ref=v1.0.24"

  aws_region       = local.aws_region
  azs              = var.azs
  vpc_cidr         = var.vpc_cidr
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  environment_name = local.environment_name
  cluster_name     = local.environment_name
  tags             = local.tags
}

variable "aws_region" {}
variable "environment" {}
variable "azs" {}
variable "vpc_cidr" {}
variable "private_subnets" {}
variable "public_subnets" {}
