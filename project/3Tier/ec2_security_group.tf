############################################################################
# Bastion EC2 Security Group
############################################################################
resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-public_ec2-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${local.name_prefix}-public_ec2-sg"
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

############################################################################
# SSH Common Security Group
############################################################################
resource "aws_security_group" "bastion_common" {
  name        = "${local.name_prefix}-common-ssh"
  description = "Allow SSH Inbound from bastion"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${local.name_prefix}-bastion_common"
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.bastion.id]
    description     = "Allow ssh inbound from bastion"
  }

  depends_on = [
    aws_security_group.bastion
  ]

  lifecycle {
    create_before_destroy = true
  }
}


############################################################################
# Bastion EC2 Security Group Rules
############################################################################
resource "aws_security_group_rule" "bastion_cidrs" {
  count = length(var.source_bastion_cidrs)
  type  = "ingress"

  description       = var.source_bastion_cidrs[count.index].desc
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = var.source_bastion_cidrs[count.index].cidrs
  from_port         = var.source_bastion_cidrs[count.index].from
  to_port           = var.source_bastion_cidrs[count.index].to
  protocol          = var.source_bastion_cidrs[count.index].protocol
}

############################################################################
# WEB EC2 Security Group
############################################################################
resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name        = "${local.name_prefix}-web-sg"
    Environment = var.tags.Environment
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

############################################################################
# WEB EC2 Security Group Rules
############################################################################
resource "aws_security_group_rule" "web_cidrs" {
  count = length(var.source_web_cidrs)
  type  = "ingress"

  description       = var.source_web_cidrs[count.index].desc
  security_group_id = aws_security_group.web.id
  cidr_blocks       = var.source_web_cidrs[count.index].cidrs
  from_port         = var.source_web_cidrs[count.index].from
  to_port           = var.source_web_cidrs[count.index].to
  protocol          = var.source_web_cidrs[count.index].protocol
}

############################################################################
# WAS EC2 Security Group
############################################################################
resource "aws_security_group" "was" {
  name        = "${local.name_prefix}-was-sg"
  description = "WAS EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name        = "${local.name_prefix}-was-sg"
    Environment = var.tags.Environment
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

############################################################################
# WAS EC2 Security Group Rules
############################################################################
resource "aws_security_group_rule" "was_cidrs" {
  count = length(var.source_was_cidrs)
  type  = "ingress"

  description       = var.source_was_cidrs[count.index].desc
  security_group_id = aws_security_group.was.id
  cidr_blocks       = var.source_was_cidrs[count.index].cidrs
  from_port         = var.source_was_cidrs[count.index].from
  to_port           = var.source_was_cidrs[count.index].to
  protocol          = var.source_was_cidrs[count.index].protocol
}

############################################################################
# Jenkins EC2 Security Group
############################################################################
resource "aws_security_group" "jenkins" {
  name        = "${local.name_prefix}-jenkins_ec2-sg"
  description = "Jenkins EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name        = "${local.name_prefix}-jenkins-sg"
    Environment = var.tags.Environment
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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