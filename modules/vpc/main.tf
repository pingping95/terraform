locals {
  vpc_id = element(
    concat(
      aws_vpc.my_vpc.*.id,
      [""],
    ),
    0,
  )
}

#######################################################################################################################
# VPC
#######################################################################################################################
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}


#######################################################################################################################
# Public Subnet
#######################################################################################################################

resource "aws_subnet" "my_public_subnets" {
  count                   = length(var.public_subnet_cidr) > 0 ? length(var.public_subnet_cidr) : 0
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.available_azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name        = "${var.env}-public-subnet-0${count.index + 1}"
    Environment = var.env
  }
}

#######################################################################################################################
# Private Subnet
#######################################################################################################################
resource "aws_subnet" "my_private_subnets" {
  count                   = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.available_azs, count.index))) > 0 ? element(var.available_azs, count.index) : null
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.env}-private-subnet-0${count.index + 1}"
    Environment = var.env
  }
}

#######################################################################################################################
# DB Subnet
#######################################################################################################################
resource "aws_subnet" "db_subnets" {
  count = length(var.db_subnet_cidr) > 0 ? length(var.db_subnet_cidr) : 0

  
  vpc_id = local.vpc_id
  cidr_block = var.db_subnet_cidr[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(var.available_azs, count.index))) > 0 ? element(var.available_azs, count.index) : null

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-db-subnet-0${count.index + 1}"
    Environment = var.env
  }
}

#######################################################################################################################
# Internet Gateway
#######################################################################################################################
resource "aws_internet_gateway" "my_igw" {
  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
  }
}

#######################################################################################################################
# Elastic IP for NAT Gateway
#######################################################################################################################
resource "aws_eip" "nat_eip" {
  vpc = var.define_eip
}

#######################################################################################################################
# NAT Gateway
#######################################################################################################################
resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my_public_subnets[0].id
  depends_on    = [aws_internet_gateway.my_igw]
  tags = {
    "Name" = "${var.env}-nat_gw"
  }
}

#######################################################################################################################
# Public Route Table
#######################################################################################################################
resource "aws_route_table" "public_rt" {
  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.env}-public_rt"
    Environment = var.env
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id

  timeouts {
    create = "5m"
  }
}


#######################################################################################################################
# Private Route Table
#######################################################################################################################
resource "aws_route_table" "private_rt" {
  count = length(var.private_subnet_cidr) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }

  tags = {
    Name        = "${var.env}-private_rt"
    Environment = var.env
  }
}


#######################################################################################################################
# DB Route Table
#######################################################################################################################
resource "aws_route_table" "database_rt" {
  vpc_id = local.vpc_id

  tags = {
    Name        = "${var.env}-database_rt"
    Environment = var.env
  }
}

#######################################################################################################################
# Route Table Association
#######################################################################################################################
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.my_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0

  subnet_id      = element(aws_subnet.my_private_subnets.*.id, count.index)
  route_table_id = element(
    aws_route_table.private_rt.*.id, count.index)
}