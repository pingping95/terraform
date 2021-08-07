# Environment
env = "test"

# Profile, Region Name
profile_name = "default"
cred_file    = "~/.aws/credentials"
region       = "ap-northeast-2"

# VPC Configurations
cidr_block          = "10.0.0.0/16" # VPC CIDR Block
public_subnet_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidr = ["10.0.10.0/24", "10.0.11.0/24"]
db_subnet_cidr      = ["10.0.20.0/24", "10.0.21.0/24"]
available_azs       = ["ap-northeast-2a", "ap-northeast-2c"]

# EC2 Configurations
default_instance_type = "t2.micro"
key_pair      = "pingping95-key"

jenkins_instance_type = "t3.small"
jenkins_instance_profile = "test_profile"

# Security Groups
# tuple : list of {description, source_cidr, from, to, protocol}
source_bastion_cidrs = [
  {
    desc     = "Bastion SSH Inbound",
    cidrs    = ["0.0.0.0/0"],
    from     = 22,
    to       = 22,
    protocol = "tcp",
  },
]

source_web_cidrs = [
  {
    desc     = "WEB HTTP Inbound",
    cidrs    = ["0.0.0.0/0"],
    from     = 80,
    to       = 80,
    protocol = "tcp",
  },
]

source_was_cidrs = [
  {
    desc     = "WAS HTTP Inbound",
    cidrs    = ["0.0.0.0/0"],
    from     = 8080,
    to       = 8080,
    protocol = "tcp",
  },
]

// Launch Template
web_instance_type = "t2.small"
was_instance_type = "t2.small"

web_ami_version = "v0.1"
was_ami_version = "v0.1"

web_lt_default_version = 1
was_lt_default_version = 1

// AutoScaling

web_asg_version = "$Default"
was_asg_version = "$Default"

web_asg_capacity = {
  desired = 1
  min = 1,
  max = 2,
}

was_asg_capacity = {
  desired = 1
  min = 1,
  max = 2,
}

// ASG Policy
// 1. WEB
web_adjustment_type = "ChangeInCapacity"
web_cpu_scaleup_threshold = 60
web_cpu_scaledown_threshold = 20

// 2. WAS
was_adjustment_type = "ChangeInCapacity"
was_cpu_scaleup_threshold = 60
was_cpu_scaledown_threshold = 20
was_instance_profile = "CodeDeployRoleProfile"

// SNS
asg_noti_endpoint = "taehun.kim@bespinglobal.com"

// Route 53, ALB, ACM
domain = "pingping2.shop"


// Database

// Global
db_name = "global"

// Param Group
db_family = "mysql5.7"

// DB Instance
db_identifier = "test-mysql-57"
db_engine = "mysql"
db_engine_version = "5.7"
db_allocated_storage = "30"
db_instance_class = "db.t3.micro"
db_multi_az = false

db_username = "admin"
db_password = "passw0rd1!"

// Option Group
db_engine_name = "mysql"
db_major_engine_version = "5.7"