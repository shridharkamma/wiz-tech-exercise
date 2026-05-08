terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "wiztestv1-tfstate-985539797171"
    key          = "wiz-tech-exercise/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}