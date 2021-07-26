variable "env" {
  default     = "dev"
  description = "Environment you would like to deploy. test, dev, stg, prod, and so on"
}

variable "profile_name" {
  default     = "default"
  description = "pick a profile name at ~/.aws/credentials"
}

variable "cred_file" {
  default = "~/.aws/credentials"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  description = "AWS VPC CIDR Block"
}

variable "public_subnet_cidr" {
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "AWS Public Subnet CIDR Block"
}

variable "private_subnet_cidr" {
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
  description = "AWS Private Subnet CIDR Block"
}

variable "region" {
  default     = "ap-northeast-2"
  description = "The primary AWS region where all the resources will be created"
}

variable "available_azs" {
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
  description = "AWS Available AZs you would like to deploy."
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 Instance Type"
}

variable "key_pair" {
  default = "pingping95-key"
}