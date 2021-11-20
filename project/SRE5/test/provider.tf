terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.6"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region_name
  shared_credentials_file  = var.cred_path
  profile = var.profile_name
}