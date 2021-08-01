// Route 53
// 1. AWS Route53 Zone
// 2. Records (cname, a, ..)

resource "aws_route53_zone" "pingping2_shop" {
    name = "pingping2.shop"
}

resource "aws_route53_record" "www_cname_pingping95_shop" {
  zone_id = aws_route53_zone.pingping2_shop.zone_id
  name    = "www.pingping2.shop."
  type    = "CNAME"
  ttl     = "300"
  records = ["pingping2.shop"]
}