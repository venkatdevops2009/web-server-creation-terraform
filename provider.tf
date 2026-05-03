terraform {
  required_version = "~> 1.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.43.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  =  var.region
}