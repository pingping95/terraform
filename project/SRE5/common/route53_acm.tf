// Route 53
resource "aws_route53_zone" "pingping2_shop" {
  name = var.domain_name
}

resource "aws_route53_record" "cname_pingping95_shop" {
  for_each = toset(var.cname)
  name = "${each.value}.${var.domain_name}"

  zone_id = aws_route53_zone.pingping2_shop.zone_id
  records = [var.domain_name]
  type = "CNAME"
  ttl = "300"
}

// ACM
resource "aws_acm_certificate" "pingping2_shop" {
  domain_name               = aws_route53_zone.pingping2_shop.name
  subject_alternative_names = ["www.${aws_route53_zone.pingping2_shop.name}"]
  validation_method         = "DNS"

  tags = {
    Name  = "${var.domain_name}-acm"
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
      name   = "${dvo.resource_record_name}"
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.pingping2_shop.id
}

// AWS ACM Certificate Validation
resource "aws_acm_certificate_validation" "pingping2_shop_validation" {
  timeouts {
    create = "10m"
  }

  certificate_arn         = aws_acm_certificate.pingping2_shop.arn
  validation_record_fqdns = [for record in aws_route53_record.pingping2_shop_acm_cname : record.fqdn]
}



///////////////////////////////////////////////////
// Virginia ACM ///////////////////////////////////
///////////////////////////////////////////////////

// ACM
resource "aws_acm_certificate" "pingping2_shop-virginia" {
  provider = aws.virginia // Virginia Region 지정

  domain_name               = aws_route53_zone.pingping2_shop.name
  subject_alternative_names = ["www.${aws_route53_zone.pingping2_shop.name}"]
  validation_method         = "DNS"

  tags = {
    Name  = "${var.domain_name}-acm"
    Owner = "taehun.kim"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Insert CNAME Record to Route 53
resource "aws_route53_record" "pingping2_shop_acm_cname-virginia" {
  provider = aws.virginia // Virginia Region 지정

  for_each = {
    for dvo in aws_acm_certificate.pingping2_shop-virginia.domain_validation_options : dvo.domain_name => {
      name   = "${dvo.resource_record_name}"
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id         = aws_route53_zone.pingping2_shop.id
  allow_overwrite = true
  ttl             = 60

  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
}

// AWS ACM Certificate Validation
resource "aws_acm_certificate_validation" "pingping2_shop_validation-virginia" {
  provider = aws.virginia // Virginia Region 지정

  timeouts {
    create = "10m"
  }

  certificate_arn         = aws_acm_certificate.pingping2_shop-virginia.arn
  validation_record_fqdns = [for record in aws_route53_record.pingping2_shop_acm_cname-virginia : record.fqdn]
}