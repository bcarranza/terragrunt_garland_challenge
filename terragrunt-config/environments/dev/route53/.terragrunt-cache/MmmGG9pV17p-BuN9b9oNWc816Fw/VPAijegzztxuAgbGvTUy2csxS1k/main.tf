locals {
  aws_region  = var.aws_region
  domain_name = var.domain_name
  tags = {
    ops_env              = var.enviroment
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform.old.format/aws/dev/5-route53-hostedzone",
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
      name = "route53_workspace_${local.environment_name}"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.19"

  domain_name = local.domain_name
  tags        = local.tags
}

variable "enviroment" {}
variable "aws_region" {}
variable "domain_name" {}