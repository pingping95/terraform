variable "region_name" { default = "ap-northeast-2" }

variable "profile_name" { default = "sre5_taehun" }

variable "cred_path" { default = "/home/user/.aws/credentials" }

variable "common_tag" {
  type = map(any)
  default = {
    region = "an2"
    env = "test"
    owner = "taehun.kim"
  }
}

variable "default_ec2" {
  type = map(any)
  default = {
    instance_type = "t3.small"
    count = 1
  }
}