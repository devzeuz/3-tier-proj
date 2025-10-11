provider "aws" {
  region = var.aws_region
}

terraform {
  cloud {
    organization = "practice-lab-"

    workspaces {
      name = "3-tier-proj"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}