## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.my_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat-gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.private_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_rt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.my_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.my_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.my_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_Environment"></a> [Environment](#input\_Environment) | Environment for resource tags. | `string` | `"dev"` | no |
| <a name="input_available_azs"></a> [available\_azs](#input\_available\_azs) | Availibility zones | `list(string)` | n/a | yes |
| <a name="input_define_eip"></a> [define\_eip](#input\_define\_eip) | Set elastic ip. 'true' or 'false'. | `bool` | `true` | no |
| <a name="input_private_subnet_cidr"></a> [private\_subnet\_cidr](#input\_private\_subnet\_cidr) | Subnet CIDRs for private subnets (length must match configured availability\_zones) | `list(any)` | <pre>[<br>  "10.0.0.11/24, 10.0.0.12/24"<br>]</pre> | no |
| <a name="input_public_subnet_cidr"></a> [public\_subnet\_cidr](#input\_public\_subnet\_cidr) | Subnet CIDRs for public subnets (length must match configured availability\_zones) | `list(any)` | <pre>[<br>  "10.0.0.1/24, 10.0.0.2/24"<br>]</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_my_eip"></a> [my\_eip](#output\_my\_eip) | Output details of my private subnet |
| <a name="output_my_private_subnets"></a> [my\_private\_subnets](#output\_my\_private\_subnets) | Output details of my private subnet |
| <a name="output_my_public_subnets"></a> [my\_public\_subnets](#output\_my\_public\_subnets) | Output details of my public subnet |
| <a name="output_my_vpc"></a> [my\_vpc](#output\_my\_vpc) | Output details of my newly crated Vpc |
