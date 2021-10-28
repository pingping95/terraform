// VPC
module "main_vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = var.cidr_block
  available_azs  = var.available_azs
  // Subnet Settings
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr


  // Tags
  # vpc_tags = {
  #   "kubernetes.io/cluster/${local.cluster}" = "shared"
  # }

  private_subnet_tags = {
    "Type" = "Private"
  }

  public_subnet_tags = {
    "Type" = "Public"
  }
  // Options
  define_eip           = true
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  enable_nat_gateway   = var.enable_nat_gateway
}

///////////////////////////////////////////
// VPC Endpoint
///////////////////////////////////////////

// 1. S3 Endpoint Interface - s3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.main_vpc.vpc_id
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = module.main_vpc.private_subnets_ids
  private_dns_enabled = false

  tags = {
    Name        = "${local.name_prefix}-s3-endpoint"
    Environment = var.tags.Environment
  }
}

// 2. ECR Endpoint Interface - ecr_dkr
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = module.main_vpc.vpc_id
  service_name      = data.aws_vpc_endpoint_service.ecr_dkr.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  subnet_ids          = module.main_vpc.private_subnets_ids
  private_dns_enabled = false

  tags = {
    Name        = "${local.name_prefix}-ecr-endpoint"
    Environment = var.tags.Environment
  }
}

