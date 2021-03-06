#################################################################
# VPC Configuration
#################################################################

// CIDR
variable "cidr_block" {
  description = "Amazon Virtual Private Cloud CIDR range."
}

variable "public_subnet_cidr" {
  default     = []
  description = "AWS Public Subnet CIDR Block"
}

variable "private_subnet_cidr" {
  default     = []
  description = "AWS Private Subnet CIDR Block"
}

variable "db_subnet_cidr" {
  default     = []
  description = "AWS DB Subnet CIDR Block"
}


variable "available_azs" {
  description = "AWS Available AZs you would like to deploy."
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

// Tagging
variable "tags" {
  type        = map(string)
  description = "Default tags"
  default = {
    "Service"     = "svc"
    "Environment" = "test"
    "RegionAlias" = "apne2"
  }
}

// VPC Options
variable "enable_dns_hostnames" {
  default     = true
  description = "Enable DNS Hostname"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "Enable DNS Support"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway of Not"
  default     = true
  type        = bool
}

#################################################################
# EC2
#################################################################
variable "default_instance_type" {
  default     = ""
  description = "Default EC2 Instance Type"
}

variable "key_pair" {
  default = ""
}

#################################################################
# Security Groups
#################################################################
variable "bastion_ingress_rules" {
  description = "Bastion ingresses. From, To, Protocol, Cidrs, Desc"
  type        = list(any)
  default     = []
}

// EKS
variable "eks_enabled_log_types" {
  type    = list(string)
  default = []
}
variable "eks_version" {}

// Worker Node
variable "worker_size" {
  description = "Worker Node Size"
  type        = map(string)
  default = {
    "desired" = "2"
    "min"     = "2"
    "max"     = "2"
  }
}
# variable "desired_size" {
#   description = "Desired number of worker nodes in private subnet"
#   type        = number
# }

# variable "max_size" {
#   description = "Maximum number of worker nodes in private subnet."
#   type        = number
# }

# variable "min_size" {
#   description = "Minimum number of worker nodes in private subnet."
#   type        = number
# }

variable "worker_instance_types" {
  description = "Maximum number of worker nodes in private subnet."
  type        = list(string)
}

variable "worker_disk_size" {
  description = "Minimum number of worker nodes in private subnet."
  type        = number
}