resource "random_string" "cloudfront_rstring" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "aws_cloudfront_distribution" "web-cf" {

  origin {
    #    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    domain_name = aws_lb.web-alb.dns_name
    origin_id   = random_string.cloudfront_rstring.result

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1"
      ]
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }
  }

  enabled = true
  comment = "This cloudfront caches custom origin"

  logging_config {
    include_cookies = false
    bucket          = "${var.logging_bucket}.s3.amazonaws.com"
    prefix          = "cf-logs"
  }

  aliases = ["www.pingping2.shop"]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = random_string.cloudfront_rstring.result
    viewer_protocol_policy = "redirect-to-https" # allow-all, https-only, redirect-to-https
    min_ttl                = 1
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true

    # Cache key settings
    forwarded_values {
      headers = []
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist" # none, whitelist, blacklist
      locations        = ["KR"]      # https://ko.wikipedia.org/wiki/ISO_3166-1
    }
  }

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.virginia-pingping2_shop.arn # Virginia ACM
    ssl_support_method  = "sni-only"
  }

  depends_on = [
    aws_lb.web-alb
  ]
}

// Insert CNAME Record to Route 53
resource "aws_route53_record" "cf-pingping2_shop" {
  zone_id = data.aws_route53_zone.pingping2_shop.id
  name    = "www.${var.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.web-cf.domain_name
    zone_id                = aws_cloudfront_distribution.web-cf.hosted_zone_id
    evaluate_target_health = false
  }
}