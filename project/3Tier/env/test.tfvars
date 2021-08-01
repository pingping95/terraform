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
instance_type = "t2.micro"
key_pair      = "pingping95-key"


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

// Route 53, ALB, ACM
domain = "pingping2.shop"

// Database
db_name = "global"
db_family = "mysql5.7"
db_identifier = "test-mysql-57"
db_username = "admin"
db_password = "passw0rd1!"
db_engine_name = "mysql"
db_engine = "mysql"
db_engine_version = "5.7"
db_allocated_storage = "30"
db_major_engine_version = "5.7"
db_instance_class = "db.t3.micro"