variable "env" {
  default     = ""
  description = "Environment you would like to deploy. test, dev, stg, prod, and so on"
}

variable "profile_name" {
  default     = ""
  description = "pick a profile name at ~/.aws/credentials"
}

variable "cred_file" {
  default = ""
}

variable "region" {
  default     = ""
  description = "The primary AWS region where all the resources will be created"
}

variable "cidr_block" {
  default     = ""
  description = "AWS VPC CIDR Block"
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
  default     = []
  description = "AWS Available AZs you would like to deploy."
}

variable "instance_type" {
  default     = ""
  description = "EC2 Instance Type"
}

variable "key_pair" {
  default = ""
}

// Security Groups

variable "source_bastion_cidrs" {
  description = "web source cidrs"
  type = list(object({
    from     = number
    to       = number
    protocol = string
    cidrs    = any
    desc     = string
  }))
  default = []
}

variable "source_web_cidrs" {
  description = "web source cidrs"
  type = list(object({
    from     = number
    to       = number
    protocol = string
    cidrs    = any
    desc     = string
  }))
  default = []
}

variable "source_was_cidrs" {
  description = "was source cidrs"
  type = list(object({
    from     = number
    to       = number
    protocol = string
    cidrs    = any
    desc     = string
  }))
  default = []
}


// WEB ALB
variable "web_alb_enable_deletion_protection" {
  description = "WEB ALB Deletion Protection"
  type        = bool
  default     = false
}

variable "web_lb_name" {
  description = "WEB ALB name ex. web-alb"
  type        = string
  default     = "web-alb"
}

variable "web_port" {
  description = "WEB ALB Listener port"
  type        = string
  default     = "80"
}

// WAS NLB
variable "was_port" {
  description = "WAS NLB Listener port"
  type        = string
  default     = "8080"
}

// Launch Templates
variable "web_ami_version" {
  description = "Web AMI Version. ex. v0.1, v0.2, .."
  type        = string
  default     = "v0.1"
}

variable "was_ami_version" {
  description = "WAS AMI Version. ex. v0.1, v0.2, .."
  type        = string
  default     = "v0.1"
}

variable "disable_api_termination" {
  description = "Deletion Protection enable or not"
  type        = string
  default     = false
}

// Auto Scaling
variable "web_asg_capacity" {
  description = "WEB Autoscaling Capacity. Max, Min, Desired."
  type = object({
    min     = string
    max     = string
    desired = string
  })
  default = {
    desired = "1"
    max     = "2"
    min     = "1"
  }
}

variable "was_asg_capacity" {
  description = "WAS Autoscaling Capacity. Max, Min, Desired."
  type = object({
    min     = string
    max     = string
    desired = string
  })
  default = {
    desired = "1"
    max     = "2"
    min     = "1"
  }
}

// ACM
variable "domain" {
  type        = string
  description = "Domain Name"
}

// Database

// Option Group
variable "db_engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "db_major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = null
}

// Param Group
variable "db_family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = list(map(string))
  default     = []
}

// DB Instance
variable "db_name" {
  description = "The name of the option group"
  type        = string
  default     = ""
}

variable "db_identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
}

variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "db_engine" {
  description = "The database engine to use"
  type        = string
  default     = ""
}


variable "db_engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "db_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = null
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}