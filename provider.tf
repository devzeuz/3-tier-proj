provider "aws" {
  region = var.aws_region

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "remote" {
    organization = "learning-hcp-tf"

    workspaces {
      name = "learning-tf-workspace"
    }
  }
}