// Subnet Group
output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = element(concat(aws_db_subnet_group.this.*.id, [""]), 0)
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = element(concat(aws_db_subnet_group.this.*.arn, [""]), 0)
}

// Option Group
output "db_option_group_id" {
  description = "The db option group id"
  value       = element(concat(aws_db_option_group.this.*.id, [""]), 0)
}

output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = element(concat(aws_db_option_group.this.*.arn, [""]), 0)
}

// Param Group
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = element(concat(aws_db_parameter_group.this.*.id, [""]), 0)
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = element(concat(aws_db_parameter_group.this.*.arn, [""]), 0)
}

// DB Instance
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = element(concat(aws_db_instance.this.*.arn, [""]), 0)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = element(concat(aws_db_instance.this.*.availability_zone, [""]), 0)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = element(concat(aws_db_instance.this.*.endpoint, [""]), 0)
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = element(concat(aws_db_instance.this.*.id, [""]), 0)
}

output "db_instance_name" {
  description = "The database name"
  value       = element(concat(aws_db_instance.this.*.name, [""]), 0)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = element(concat(aws_db_instance.this.*.username, [""]), 0)
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = element(concat(aws_db_instance.this.*.port, [""]), 0)
}

output "db_instance_master_password" {
  description = "The master password"
  value       = element(concat(aws_db_instance.this.*.password, [""]), 0)
  sensitive   = true
}