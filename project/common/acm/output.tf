// This will be used in AWS LB Listener
output "pingping2_shop_acm_arn" {
    value = aws_acm_certificate.pingping2_shop.arn
}

output "pingping2_shop_name" {
    value = data.aws_route53_zone.selected.name
}