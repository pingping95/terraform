#################################################################################
// Default Settings
#################################################################################
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

#################################################################################
// Network Settings
#################################################################################

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


#################################################################################
// EC2 Settings
#################################################################################

variable "default_instance_type" {
  default     = ""
  description = "Default EC2 Instance Type"
}

variable "key_pair" {
  default = ""
}

// Jenkins
variable "jenkins_instance_type" {
  default     = ""
  description = "Jenkins EC2 Instance Type"
}

// Jenkins
variable "jenkins_instance_profile" {
  default     = ""
  description = "Jenkins IAM Profile"
}

#################################################################################
// Security Group Rules
#################################################################################

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


#################################################################################
// WEB ALB
#################################################################################
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

#################################################################################
// WAS NLB
#################################################################################
variable "was_port" {
  description = "WAS NLB Listener port"
  type        = string
  default     = "8080"
}

#################################################################################
// Launch Template
#################################################################################

// Web
variable "web_ami_version" {
  description = "Web AMI Version. ex. v1, v2, .."
  type        = string
  default     = "v1"
}

variable "web_lt_default_version" {
  description = "WEB Launch Template Default Version."
  type        = number
  default     = 1
}

variable "web_instance_type" {
  default     = ""
  description = "WEB EC2 Instance Type"
}

// Was
variable "was_ami_version" {
  description = "WAS AMI Version. ex. v1, v2, .."
  type        = string
  default     = "v1"
}

variable "was_lt_default_version" {
  description = "WAS Launch Template Default Version."
  type        = number
  default     = 1
}

variable "was_instance_type" {
  default     = ""
  description = "WAS EC2 Instance Type"
}

variable "was_instance_profile" {
  default     = ""
  description = "WAS EC2 IAM Instance Profile"
}

variable "disable_api_termination" {
  description = "Deletion Protection enable or not"
  type        = string
  default     = false
}

#################################################################################
// Auto Scaling Group
#################################################################################

variable "web_asg_version" {
  description = "Web ASG Launch Template Version. $Default, $Latest"
  type        = string
  default     = "$Default"
}

variable "was_asg_version" {
  description = "WAS ASG Launch Template Version. $Default, $Latest"
  type        = string
  default     = "$Default"
}

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
    desired = "2"
    max     = "4"
    min     = "2"
  }
}

// ASG Policy

// 1. WEB
variable "web_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity."
  type        = string
  default     = "ChangeInCapacity"
}

variable "web_cpu_scaleup_threshold" {
  description = "Threshold value for WEB ASG Scale up"
  type        = number
  default     = 60
}

variable "web_cpu_scaledown_threshold" {
  description = "Threshold value for WEB ASG Scale down"
  type        = number
  default     = 20
}

// 2. WAS
variable "was_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity."
  type        = string
  default     = "ChangeInCapacity"
}

variable "was_cpu_scaleup_threshold" {
  description = "Threshold value for WAS ASG Scale up"
  type        = number
  default     = 60
}

variable "was_cpu_scaledown_threshold" {
  description = "Threshold value for WAS ASG Scale down"
  type        = number
  default     = 20
}

// SNS
variable "asg_noti_endpoint" {
  description = "Email List of ASG Scaling Event"
  type        = string
  default     = ""
}


#################################################################################
// ACM
#################################################################################
variable "domain" {
  type        = string
  description = "Domain Name"
}


#################################################################################
// Database
#################################################################################

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