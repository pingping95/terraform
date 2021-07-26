variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
  default = "10.0.0.0/16"
}

variable "region" {
  description = "Region"
  default = "ap-northeast-2"
  type = string
}

variable "env" {
  type        = string
  description = "Environment for resource tags."
  default     = "dev"
}

variable "public_subnet_cidr" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  type        = list(any)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr" {
  description = "Subnet CIDRs for private subnets (length must match configured availability_zones)"
  type        = list(any)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "db_subnet_cidr" {
  description = "Subnet CIDRs for DB Subnets (length must match configured availability_zones)"
  type        = list(any)
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type = bool
  default = true
}

variable "available_azs" {
  type        = list(string)
  description = "Availibility zones"
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}

variable "define_eip" {
  type        = bool
  description = "Set elastic ip. 'true' or 'false'."
  default     = true
}

variable "enable_dns_hostnames" {
  default = true
  description = "Enable DNS Hostname"
  type = bool
}

variable "enable_dns_support" { 
  default = true
  description = "Enable DNS Support"
  type = bool
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway of Not"
  default = true
  type = bool
}