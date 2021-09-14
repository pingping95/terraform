locals {
  vpc_id = element(
    concat(
      aws_vpc.my_vpc.*.id,
      [""],
    ),
    0,
  )

  name_prefix = "${var.tags["Service"]}-${var.tags["Environment"]}-${var.tags["RegionAlias"]}"
}

#######################################################################################################################
# VPC
#######################################################################################################################
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      Name        = "${local.name_prefix}-vpc"
      Environment = var.tags["Environment"]
    }, var.vpc_tags
  )
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

  tags = merge(
    {
      Name        = "${local.name_prefix}-public-subnet-0${count.index + 1}"
      Environment = var.tags["Environment"]
    },
    var.public_subnet_tags
  )
}

#######################################################################################################################
# Private Subnet
#######################################################################################################################
resource "aws_subnet" "my_private_subnets" {
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0

  vpc_id                  = local.vpc_id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.available_azs, count.index))) > 0 ? element(var.available_azs, count.index) : null
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${local.name_prefix}-private-subnet-0${count.index + 1}"
      Environment = var.tags["Environment"]
    },
    var.private_subnet_tags
  )
}

#######################################################################################################################
# DB Subnet
#######################################################################################################################
resource "aws_subnet" "db_subnets" {
  count = length(var.db_subnet_cidr) > 0 ? length(var.db_subnet_cidr) : 0


  vpc_id            = local.vpc_id
  cidr_block        = var.db_subnet_cidr[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(var.available_azs, count.index))) > 0 ? element(var.available_azs, count.index) : null

  map_public_ip_on_launch = false

  tags = merge(
    {
      Name        = "${local.name_prefix}-db-subnet-0${count.index + 1}"
      Environment = var.tags["Environment"]
    },
    var.db_subnet_tags
  )
}

#######################################################################################################################
# Internet Gateway
#######################################################################################################################
resource "aws_internet_gateway" "my_igw" {
  vpc_id = local.vpc_id

  tags = {
    Name        = "${local.name_prefix}-igw"
    Environment = var.tags["Environment"]
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
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.my_public_subnets[0].id
  depends_on    = [aws_internet_gateway.my_igw]
  tags = {
    Name        = "${local.name_prefix}-nat_gw"
    Environment = var.tags["Environment"]
  }
}

#######################################################################################################################
# Public Route Table
#######################################################################################################################
resource "aws_route_table" "public_rt" {
  vpc_id = local.vpc_id

  tags = {
    Name        = "${local.name_prefix}-public_rt"
    Environment = var.tags["Environment"]
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id

  timeouts {
    create = "5m"
  }
}


#######################################################################################################################
# Private Route Table
#######################################################################################################################
resource "aws_route_table" "private_rt" {
  count  = length(var.private_subnet_cidr) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }

  tags = {
    Name        = "${local.name_prefix}-private_rt"
    Environment = var.tags["Environment"]
  }
}


#######################################################################################################################
# DB Route Table
#######################################################################################################################
resource "aws_route_table" "database_rt" {
  count  = length(var.db_subnet_cidr) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = {
    Name        = "${local.name_prefix}-database_rt"
    Environment = var.tags["Environment"]
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
  count = length(var.private_subnet_cidr) > 0 ? length(var.private_subnet_cidr) : 0

  subnet_id = element(aws_subnet.my_private_subnets.*.id, count.index)
  route_table_id = element(
  aws_route_table.private_rt.*.id, count.index)
}

resource "aws_route_table_association" "db_rt_assoc" {
  count = length(var.db_subnet_cidr) > 0 ? length(var.db_subnet_cidr) : 0

  subnet_id = element(aws_subnet.db_subnets.*.id, count.index)
  route_table_id = element(
  aws_route_table.database_rt.*.id, count.index)
}