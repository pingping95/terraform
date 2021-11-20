locals {
  tag_prefix = "${var.common_tag.env}-${var.common_tag.region}"
}

// Amazon Linux 2
data "aws_ami" "amazon2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "private-ec2" {
  count = var.default_ec2.count
  ami = data.aws_ami.amazon2.id
  instance_type = var.default_ec2.instance_type

  tags = {
    Name = "${local.tag_prefix}-taehun-ec2"
    }
}