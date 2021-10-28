// Bastion EC2
module "bastion" {
  source         = "../../modules/ec2"
  name           = "${local.name_prefix}-bastion"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.default_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_ids             = module.main_vpc.public_subnets_ids
  user_data              = base64encode(file("./scripts/common/amz2_init.sh"))

  tags = {
    Name        = "${local.name_prefix}-bastion"
    Environment = var.tags.Environment
  }
}

# module "jenkins_ec2" {
#   source                 = "../../modules/ec2"
#   name                   = "${local.name_prefix}-jenkins"
#   instance_count         = 1
#   ami                    = data.aws_ami.amazon2.id
#   instance_type          = var.jenkins_instance_type
#   key_name               = var.key_pair
#   vpc_security_group_ids = [aws_security_group.bastion.id, aws_security_group.jenkins.id]
#   subnet_ids             = module.main_vpc.public_subnets_ids
#   iam_instance_profile   = var.jenkins_instance_profile
#   user_data              = base64encode(file("./scripts/common/jenkins_install.sh"))
#   tags = {
#     Name        = "${local.name_prefix}-jenkins"
#     Environment = var.tags.Environment
#   }
# }


/* // Web EC2
module "web" {
  source         = "../../modules/ec2"
  name           = "${local.name_prefix}-web"
  instance_count = 1
  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.web.id, aws_security_group.bastion_common.id]
  subnet_ids             = module.main_vpc.private_subnets_ids
  tags = {
    Environment = local.name_prefix
  }
}

// WAS EC2
module "was" {
  source         = "../../modules/ec2"
  name           = "${local.name_prefix}-was"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.default_instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [aws_security_group.was.id, aws_security_group.bastion_common.id]
  subnet_ids             = module.main_vpc.private_subnets_ids

  user_data = base64encode(file("./scripts/was/tomcat_install.sh"))

  tags = {
    Environment = local.name_prefix
  }
} */