// RDS EC2 Security Group
resource "aws_security_group" "mysql_rds" {
  name        = "${var.env}-${var.db_name}-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-${var.db_name}-sg"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

module "mysql57" {
  source = "../../modules/rds/mysql"

  name   = var.db_name
  region = var.region
  env    = var.env

  // Network & Security
  subnet_ids             = module.main_vpc.db_subnets_ids
  vpc_security_group_ids = [aws_security_group.mysql_rds.id]

  // Instance
  identifier        = var.db_identifier
  family            = var.db_family
  engine            = var.db_engine
  engine_name       = var.db_engine_name
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  engine_version       = var.db_engine_version
  major_engine_version = var.db_major_engine_version
  multi_az             = var.db_multi_az

  // Username, Password (Sensitive)
  username = var.db_username
  password = var.db_password
}