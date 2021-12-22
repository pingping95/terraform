// Network Config
data "aws_vpc" "selected" {
  id = var.network_config.vpc_id
}


// Amazon Linux 2
data "aws_ami" "amazon2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

// ACM Certificate
data "aws_acm_certificate" "seoul-pingping2_shop" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

// ACM Certificate
// For cloudfront ssl certificate.
data "aws_acm_certificate" "virginia-pingping2_shop" {
  provider = aws.virginia
  domain   = var.domain
  statuses = ["ISSUED"]
}

// Route 53
data "aws_route53_zone" "pingping2_shop" {
  name = var.domain
}



// S3 Bucket
data "aws_s3_bucket" "logging" {
  bucket = var.logging_bucket
}