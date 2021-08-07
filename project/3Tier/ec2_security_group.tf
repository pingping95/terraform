############################################################################
# Bastion EC2 Security Group
############################################################################
resource "aws_security_group" "bastion" {
  name        = "${var.env}-public_ec2-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-public_ec2-sg"
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
  name        = "${var.env}-common-ssh"
  description = "Allow SSH Inbound from bastion"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-bastion_common"
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
  name        = "${var.env}-web-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-web-sg"
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
  name        = "${var.env}-was-sg"
  description = "WAS EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-was-sg"
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
  name        = "${var.env}-jenkins_ec2-sg"
  description = "Jenkins EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-jenkins_ec2-sg"
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