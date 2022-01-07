
/*Terraform file source */
/*all  var.* variables are matched with the file ./enviroments/$enviroment/eks_autoscaler/terragrunt.hcl*/

locals {
  aws_region       = var.aws_region
  environment_name = var.environment
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
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
  }

  backend "remote" {
    organization = ${local.organization_name}

    workspaces {
      name = "${local.workspace_eks_autoscaler_name}_${local.environment_name}"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

data "terraform_remote_state" "eks" {
  backend = "remote"
  config = {
    organization = ${local.organization_name}
    workspaces = {
      name = "${local.workspace_eks_name}_${local.environment_name}"
    }
  }
}

#
# EKS authentication
# # https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", "${local.environment_name}"]
      command     = "aws"
    }
  }
}

#
# Helm - cluster-autoscaler
#
module "cluster-autoscaler" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/cluster-autoscaler?ref=v1.0.12"

  aws_region                  = local.aws_region
  cluster_name                = local.environment_name
  eks_cluster_id              = data.terraform_remote_state.eks.outputs.cluster_id
  eks_cluster_oidc_issuer_url = data.terraform_remote_state.eks.outputs.cluster_oidc_issuer_url

  depends_on = [
    data.terraform_remote_state.eks
  ]
}

/*BC: Declaration of input variables matching the file ./enviroments/$enviroment/eks_autoscaler/terragrunt.hcl*/
variable "environment" {}
variable "aws_region" {}
variable "organization_name" {}
variable "workspace_eks_name" {}
variable "workspace_eks_autoscaler_name" {}