////////////////////////////////////
// 1. Common SSH From Bastion
////////////////////////////////////
resource "aws_security_group" "common_ssh" {
  name        = "${local.name_prefix}-common_ssh"
  description = "Allow SSH Inbound from bastion"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${local.name_prefix}-common_ssh"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
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

////////////////////////////////////
// 2. Bastion SG
////////////////////////////////////
resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${local.name_prefix}-bastion-sg"
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

// [Rule] Bastion SG Inbound
resource "aws_security_group_rule" "bastion_cidrs" {
  count             = length(var.bastion_ingress_rules)
  security_group_id = aws_security_group.bastion.id
  type              = "ingress"

  from_port   = var.bastion_ingress_rules[count.index][0]
  to_port     = var.bastion_ingress_rules[count.index][1]
  protocol    = var.bastion_ingress_rules[count.index][2]
  cidr_blocks = var.bastion_ingress_rules[count.index][3]
  description = var.bastion_ingress_rules[count.index][4]
}

////////////////////////////////////
// 3. VPC Endpoint SG
////////////////////////////////////

resource "aws_security_group" "vpc_endpoint" {
  name        = "${local.name_prefix}-vpc-endpoint-sg"
  description = "Security Group used by VPC Endpoints."
  vpc_id      = module.main_vpc.vpc_id

  tags = {
    "Name" = "${local.name_prefix}-vpc-endpoint-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// [Rule] VPC Endpoint
resource "aws_security_group_rule" "vpc_endpoint_egress" {
  security_group_id = aws_security_group.vpc_endpoint.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]

  depends_on = [
    aws_security_group.vpc_endpoint
  ]
}

// VPC 대역으로만 HTTPS Inbound 허용
resource "aws_security_group_rule" "vpc_endpoint_ingress" {
  security_group_id = aws_security_group.vpc_endpoint.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = [module.main_vpc.vic_cidr_block]

  depends_on = [
    aws_security_group.vpc_endpoint
  ]
}

////////////////////////////////////
// 4. Nodejs_app Fargate TASK SG (8080)
////////////////////////////////////
resource "aws_security_group" "nodejs_app_container" {
  name = "${local.name_prefix}-nodejs_app-container-sg"
  description = "Nodejs app container sg for nodejs_app ECS Fargate"
  vpc_id = module.main_vpc.vpc_id

  tags = {
    Name = "${local.name_prefix}-nodejs_app-container-sg"
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

// [Rule] Nodejs_app Fargate TASK Inbound rule (8080)
resource "aws_security_group_rule" "nodejs_app_container" {
  count             = length(var.nodejs_app_ingress_rules)
  security_group_id = aws_security_group.nodejs_app_container.id
  type              = "ingress"

  from_port   = var.nodejs_app_ingress_rules[count.index][0]
  to_port     = var.nodejs_app_ingress_rules[count.index][1]
  protocol    = var.nodejs_app_ingress_rules[count.index][2]
  cidr_blocks = var.nodejs_app_ingress_rules[count.index][3]
  description = var.nodejs_app_ingress_rules[count.index][4]
}