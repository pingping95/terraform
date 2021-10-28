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
  default     = ""
  description = "Key Pair for Bastion EC2 instance"
}


variable "domain" {
  type        = string
  description = "Domain Name"
}


#################################################################
# Security Groups
#################################################################
variable "bastion_ingress_rules" {
  description = "Bastion ingresses. From, To, Protocol, Cidrs, Desc"
  type        = list(any)
  default     = []
}

variable "nodejs_app_ingress_rules" {
  description = "nodejs_app_ingress_rules ingresses. From, To, Protocol, Cidrs, Desc"
  type        = list(any)
  default     = []
}

// ECS


// ELB

variable "nodejs_app_alb_enable_deletion_protection" {
  default     = true
  type        = bool
  description = "nodejs_app_alb Deletion Termination API"
}

variable "backend_port" {
  type        = string
  description = "Backend Port"
}