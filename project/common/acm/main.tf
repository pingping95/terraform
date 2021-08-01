locals {
    pingping_shop_id = data.aws_route53_zone.selected.id
}

// Create ACM Certificate
resource "aws_acm_certificate" "pingping2_shop" {
    domain_name       = data.aws_route53_zone.selected.name
    subject_alternative_names = ["www.${data.aws_route53_zone.selected.name}"]
    validation_method = "DNS"

    tags = {
        Name                = "${var.root_domain}-acm"
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
    zone_id = data.aws_route53_zone.selected.id
}

// AWS ACM Certificate Validation
resource "aws_acm_certificate_validation" "pingping2_shop_validation" {
    timeouts {
      create = "10m"
    }

    certificate_arn = aws_acm_certificate.pingping2_shop.arn
    validation_record_fqdns = [for record in aws_route53_record.pingping2_shop_acm_cname : record.fqdn]
}