data "aws_route53_zone" "selected" {
    private_zone = false
    name = var.root_domain
}