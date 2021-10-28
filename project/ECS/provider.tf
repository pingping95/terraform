provider "aws" {
  region                  = var.region
  shared_credentials_file = var.cred_file
  profile                 = var.profile_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.42"
    }
  }

  backend "s3" {
    bucket = "pingping95-tfstate-bucket"
    key    = "terraform/ecs.tfstate"
    region = "ap-northeast-2"
  }
}