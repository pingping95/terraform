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