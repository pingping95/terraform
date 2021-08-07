// Cller Identity
data "aws_caller_identity" "current" {

}


// Windows 2019
data "aws_ami" "windows2019" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }
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

// CentOS 7 
data "aws_ami" "centos7" {
  most_recent = true
  owners      = ["679593333241"] # CentOS Project

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS ENA*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

// Ubuntu 20.04
data "aws_ami" "ubuntu-20_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

// Ubuntu 18.04
data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

// IAM Role

// ACM Certificate
data "aws_acm_certificate" "web" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

// Route 53
data "aws_route53_zone" "pingping2_shop" {
  name = var.domain
}

// Get AMI Id from data - aws_ami_ids
data "aws_ami" "web" {
  owners = [data.aws_caller_identity.current.account_id]
  filter {
    name   = "name"
    values = ["WEB-AMI-${var.web_ami_version}"] //v0.1, v0.2, ..
  }
}

// Get AMI Id from data - aws_ami_ids
data "aws_ami" "was" {
  owners = [data.aws_caller_identity.current.account_id]
  filter {
    name   = "name"
    values = ["test-WAS-AMI-${var.was_ami_version}"] //v0.1, v0.2, ..
  }
}