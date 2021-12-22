# This is Symbolic Link file.
# Managed at ../common/variables/global_vars.tf file.
variable "profile_name" {
  default     = "sre5_taehun"
  description = "pick a profile name at ~/.aws/credentials"
}

variable "cred_file" {
  default = "/home/user/.aws/credentials"
}

variable "region" {
  default     = "ap-northeast-2"
  description = "The primary AWS region where all the resources will be created"
}