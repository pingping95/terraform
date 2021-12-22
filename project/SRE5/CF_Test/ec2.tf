// Bastion EC2
module "web" {
  source         = "../../../modules/ec2"
  name           = "${local.name_prefix}-web-ec2"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.ec2.instance_type
  key_name               = var.ec2.keypair
  vpc_security_group_ids = [aws_security_group.web.id]
  subnet_ids             = local.pri_subnets
  user_data              = base64encode(file("./scripts/common/amz2_init.sh"))

  tags = {
    Name        = "${local.name_prefix}-web-ec2"
    Owner       = var.tags.OwnerTag
    Environment = var.tags.Environment
  }
}

############################################################################
# WEB EC2 Security Group
############################################################################
resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "Public EC2 Security Group"
  vpc_id      = data.aws_vpc.selected.id
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

// [Rule] WEB Ingress Inbound
resource "aws_security_group_rule" "web-ingress-cidrs" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id

  // Dynamic
  for_each    = var.web_ingress_rules
  from_port   = each.value.from
  to_port     = each.value.to
  protocol    = each.value.proto
  cidr_blocks = each.value.cidr
  description = each.value.desc
}