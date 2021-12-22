variable "config" {
  description = "Initial Setting Configuration"
  type        = map(string)
  default = {
    region       = "ap-northeast-2"
    cred_file    = "/home/user/.aws/credentials"
    profile_name = "sre5_taehun"
  }
}

variable "network_config" {
  description = "Network Configurations. ex) VPC, Subnet, ..."
  default     = {}
}

// EC2 Instance
variable "ec2" {
  description = "EC2 Instance information"
  default     = {}
}

variable "web_ingress_rules" {
  type = map(object(
    {
      from  = number
      to    = number
      proto = string
      cidr  = list(string)
      desc  = string
    }
  ))

  default = {}
}

variable "web_alb_ingress_rules" {
  type = map(object(
    {
      from  = number
      to    = number
      proto = string
      cidr  = list(string)
      desc  = string
    }
  ))

  default = {}
}

// Route53, ACM, Domain
variable "domain" {
  description = "Domain name"
  type        = string
  default     = "pingping2.shop"
}


// S3 Bucket
variable "logging_bucket" {
  type        = string
  description = "Logging bucket for cloudfront"
}


// Tagging
variable "tags" {
  type        = map(string)
  description = "Default tags"
  default = {
    "Service"     = "svc"
    "Environment" = "test"
    "RegionAlias" = "apne2"
    "OwnerTag"    = "taehun.kim"
  }
}