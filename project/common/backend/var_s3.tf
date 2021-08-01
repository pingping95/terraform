variable "env" {
  default     = "test"
  description = "Environment you would like to deploy. test, dev, stg, prod, and so on"
}

variable "profile_name" {
  default     = "default"
  description = "pick a profile name at ~/.aws/credentials"
}

variable "cred_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default     = "ap-northeast-2"
  description = "The primary AWS region where all the resources will be created"
}

variable "s3_versioning" {
    default = false
    type = bool
    description = "Enable S3 Versioning or not"
}