// VPC
module "main_vpc" {
  source              = "../../modules/vpc"
  vpc_cidr_block      = var.cidr_block
  env                 = var.env
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr
  available_azs       = var.available_azs
  define_eip          = true
}