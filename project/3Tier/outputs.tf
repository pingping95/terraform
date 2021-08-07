/* // Subnets
output "vpc_id" {
  value = module.main_vpc.vpc_id
}
output "public_subnet_ids" {
  value = module.main_vpc.my_public_subnets_ids
}
output "private_subnet_ids" {
  value = module.main_vpc.my_private_subnets.*.id
}
output "bastion_sg_id" {
    value = aws_security_group.bastion.id
}
output "ami_ids" {
    value = data.aws_ami_ids.ami
} */
output "bastion_public_ip" {
  value = module.bastion2.public_ip
}
output "jenkins_public_ip" {
  value = module.jenkins_ec2.public_ip
}