// Subnet Group
resource "aws_db_subnet_group" "this" {
  name        = "${var.env}-${var.name}-sg"
  description = "${var.env}-${var.name} will be created in this subnet group"
  subnet_ids  = var.subnet_ids

  tags = {
    "Name" = "${var.env}-${var.name}-sg"
  }
}

// DB Option Group
resource "aws_db_option_group" "this" {
  name                     = "${var.env}-${var.name}-option-group"
  option_group_description = "Option Group for ${var.env}-${var.name}"
  engine_name              = var.engine_name
  major_engine_version     = var.major_engine_version

  dynamic "option" {
    for_each = var.options
    content {
      option_name                    = option.value.option_name
      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }

  tags = {
    "Name" = "${var.env}-${var.name}-option_group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Param Group
resource "aws_db_parameter_group" "this" {
  name        = "${var.env}-${var.name}-param-group"
  description = "Parameter Group for ${var.env}-${var.name}"
  family      = var.family

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = {
    "Name" = "${var.env}-${var.name}-param_group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// DB Instance
resource "aws_db_instance" "this" {
  identifier = var.identifier

  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_encrypted = var.storage_encrypted

  skip_final_snapshot  = true

  name                                = var.name
  username                            = var.username
  password                            = var.password
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.this.name
  parameter_group_name   = aws_db_parameter_group.this.name
  option_group_name      = aws_db_option_group.this.name

  availability_zone   = var.availability_zone
  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  deletion_protection = var.deletion_protection

  apply_immediately = var.apply_immediately

  // Todo
  // Performance Insight, backup_window, ..

  tags = {
    "Environment" = var.env
    "Name"        = format("%s-%s", var.env, var.identifier)
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}