// Route 53
resource "aws_route53_zone" "pingping2_shop" {
  name = var.domain_name
}

resource "aws_route53_record" "www_cname_pingping95_shop" {
  zone_id = aws_route53_zone.pingping2_shop.zone_id
  name    = "www.${var.domain_name}."
  type    = "CNAME"
  ttl     = "300"
  records = [var.domain_name]
}

// ACM
resource "aws_acm_certificate" "pingping2_shop" {
  domain_name = aws_route53_zone.pingping2_shop.name
    subject_alternative_names = ["www.${aws_route53_zone.pingping2_shop.name}"]
    validation_method = "DNS"

    tags = {
        Name                = "${var.domain_name}-acm"
        Owner = "taehun.kim"
    }

    lifecycle {
        create_before_destroy = true
  }
}

// Insert CNAME Record to Route 53
resource "aws_route53_record" "pingping2_shop_acm_cname" {
    for_each = {
      for dvo in aws_acm_certificate.pingping2_shop.domain_validation_options : dvo.domain_name => {
          name = "${dvo.resource_record_name}"
          record = dvo.resource_record_value
          type = dvo.resource_record_type
      }
    }

    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = aws_route53_zone.pingping2_shop.id
}

// AWS ACM Certificate Validation
resource "aws_acm_certificate_validation" "pingping2_shop_validation" {
    timeouts {
      create = "10m"
    }

    certificate_arn = aws_acm_certificate.pingping2_shop.arn
    validation_record_fqdns = [for record in aws_route53_record.pingping2_shop_acm_cname : record.fqdn]
}