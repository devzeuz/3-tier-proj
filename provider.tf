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

  cloud {
    organization = "practice-lab-"

    workspaces {
      name = "3-tier-proj"
    }
  }

  required_version = ">= 1.5.0"
}