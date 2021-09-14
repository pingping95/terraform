
source "amazon-ebs" "ec2_ami" {
    profile = var.profile
    region = var.region
    ami_name = "${var.env}-WAS-AMI-${var.version}"
    instance_type = var.instance_type
    source_ami_filter {
        filters = {
            virtualization-type = "hvm"
            name                = "amzn2-ami-ecs-hvm-2*"
            root-device-type    = "ebs"
            architecture        = "x86_64"
        }
        owners                = ["amazon"]
        most_recent           = true
    }

    # Network Configuration
    subnet_id = var.subnet_id
    ssh_timeout = "10m"

    # Temporarily connect to EC2 using ssh protocol,
    # ssh ec2-user@{{public_ip}}
    communicator              = "ssh"
    ssh_username              = "ec2-user"
}

build {
    # Get EC2 Image
    sources = [
        "source.amazon-ebs.ec2_ami"
    ]

    # Provisioner
    provisioner "shell" {
        script = "tomcat_install.sh"
    }
}

# Variable Settings
variable "profile" {}

variable "region" {}

variable "env" {}

variable "instance_type" {}

variable "subnet_id" {}

variable "version" {}