locals {
  aws_region       = var.aws_region
  environment_name = var.environment
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform.old.format/aws/${local.environment_name}/20-eks",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }

  backend "remote" {
    organization = "managedkube1"

    workspaces {
      name = "eks_workspace_${local.environment_name}"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "managedkube1"
    workspaces = {
      name = "vpc_workspace_${local.environment_name}"
    }
  }
}

#
# EKS
#
module "eks" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/eks?ref=v1.0.25"

  aws_region = local.aws_region
  tags       = local.tags

  cluster_name = local.environment_name

  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  k8s_subnets    = data.terraform_remote_state.vpc.outputs.k8s_subnets
  public_subnets = data.terraform_remote_state.vpc.outputs.public_subnets

  cluster_version = var.cluster_version

  # public cluster - kubernetes API is publicly accessible
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  # private cluster - kubernetes API is internal the the VPC
  cluster_endpoint_private_access                = true
  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = var.cluster_endpoint_private_access_cidrs

  map_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
  map_users = [
    {
      userarn  = "arn:aws:iam::725654443526:user/username"
      username = "username"
      groups   = ["system:masters"]
    },
  ]

  node_groups = {
    ng1 = {
      version          = var.node_version
      disk_size        = var.disk_size
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_types   = var.instance_types
      additional_tags  = local.tags
      k8s_labels       = {}
    }
  }

  # depends_on = [
  #   module.vpc
  # ]
}

variable "aws_region" {}
variable "environment" {}
variable "cluster_version" {}
variable "cluster_endpoint_public_access_cidrs" {}
variable "cluster_endpoint_private_access_cidrs" {}
variable "node_version" {}
variable "disk_size" {}
variable "desired_capacity" {}
variable "max_capacity" {}
variable "min_capacity" {}
variable "instance_types" {}


