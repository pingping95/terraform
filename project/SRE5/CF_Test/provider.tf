provider "aws" {
  region                  = var.config.region
  shared_credentials_file = var.config.cred_file
  profile                 = var.config.profile_name
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.6"
    }
  }

  backend "s3" {
    bucket                  = "taehun-test-an2-tfstate"
    key                     = "an2/cf_test/test.tfstate"
    region                  = "ap-northeast-2"
    profile                 = "sre5_taehun"
    shared_credentials_file = "~/.aws/credendials"
  }
}


provider "aws" {
  alias                   = "virginia"
  region                  = "us-east-1"
  shared_credentials_file = var.config.cred_file
  profile                 = var.config.profile_name
}