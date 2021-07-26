// Public EC2 Security Group
resource "aws_security_group" "public_ec2_sg" {
  name        = "${var.env}-public_ec2-sg"
  description = "Public EC2 Security Group"
  vpc_id      = module.main_vpc.vpc_id
  tags = {
    Name = "${var.env}-public_ec2-sg"
  }

  depends_on = [
      module.main_vpc
  ]
}

resource "aws_security_group_rule" "public_ec2_ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = resource.aws_security_group.public_ec2_sg.id
  description       = "SSH Inbound"

  depends_on = [
      aws_security_group.public_ec2_sg
  ]
}

resource "aws_security_group_rule" "public_ec2_ssh_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = resource.aws_security_group.public_ec2_sg.id
  description       = "Outbound"

    depends_on = [
      aws_security_group.public_ec2_sg
  ]
}