// Bastion EC2
module "bastion2" {
  source         = "../../modules/ec2"
  name           = "${var.env}-bastion"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.default_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_ids             = module.main_vpc.public_subnets_ids
  user_data              = base64encode(file("./scripts/common/amz2_init.sh"))

  tags = {
    Environment = var.env
  }
}

module "jenkins_ec2" {
  source                 = "../../modules/ec2"
  name                   = "${var.env}-jenkins"
  instance_count         = 1
  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.jenkins_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion.id, aws_security_group.jenkins.id]
  subnet_ids             = module.main_vpc.public_subnets_ids
  iam_instance_profile   = var.jenkins_instance_profile
  user_data              = base64encode(file("./scripts/common/jenkins_install.sh"))
  tags = {
    Environment = var.env
  }
}


/* // Web EC2
module "web" {
  source         = "../../modules/ec2"
  name           = "${var.env}-web"
  instance_count = 1
  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.web.id, aws_security_group.bastion_common.id]
  subnet_ids             = module.main_vpc.private_subnets_ids
  tags = {
    Environment = var.env
  }
}

// WAS EC2
module "was" {
  source         = "../../modules/ec2"
  name           = "${var.env}-was"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.default_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.was.id, aws_security_group.bastion_common.id]
  subnet_ids             = module.main_vpc.private_subnets_ids

  user_data = base64encode(file("./scripts/was/tomcat_install.sh"))

  tags = {
    Environment = var.env
  }
} */