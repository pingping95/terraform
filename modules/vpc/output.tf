// VPC Outputs
output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "Output details of my newly crated VPC Id"
}

output "vic_cidr_block" {
  description = "Output details of my newly crated VPC CIDR"
  value       = concat(aws_vpc.my_vpc.*.cidr_block, [""])[0]
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = concat(aws_vpc.my_vpc.*.enable_dns_support, [""])[0]
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = concat(aws_vpc.my_vpc.*.enable_dns_hostnames, [""])[0]
}

// Subnet Outputs
// 1. Public Subnet
output "public_subnets_ids" {
  value       = aws_subnet.my_public_subnets.*.id
  description = "Output details of my public subnets"
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.my_public_subnets.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.my_public_subnets.*.cidr_block
}

// 2. Private Subnet
output "private_subnets_ids" {
  value       = aws_subnet.my_private_subnets.*.id
  description = "Output details of my private subnets"
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.my_private_subnets.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.my_private_subnets.*.cidr_block
}

// 3. Database Subnet
output "db_subnets_ids" {
  value = aws_subnet.db_subnets.*.id
  description = "Output details of my Database subnets"
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.db_subnets.*.arn
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = aws_subnet.db_subnets.*.cidr_block
}

// IGW
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = concat(aws_internet_gateway.my_igw.*.id, [""])[0]
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = concat(aws_internet_gateway.my_igw.*.arn, [""])[0]
}

// NAT GW
output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.nat_gw.*.id
}

// Route Table IDs
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public_rt.*.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private_rt.*.id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = length(aws_route_table.database_rt.*.id) > 0 ? aws_route_table.database_rt.*.id : aws_route_table.private_rt.*.id
}