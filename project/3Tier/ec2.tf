// EC2 (Public EC2 Instances)
module "public_ec2" {
  source         = "../modules/ec2"
  name           = "${var.env}-public_ec2"
  instance_count = 1

  ami                    = data.aws_ami.amazon2.id
  instance_type          = var.instance_type
  key_name               = var.key_pair
  vpc_security_group_ids = [resource.aws_security_group.public_ec2_sg.id]
  subnet_ids             = module.main_vpc.my_public_subnets_ids

  tags = {
    Environment = var.env
  }

  depends_on = [
    resource.aws_security_group.public_ec2_sg
  ]
}