resource "aws_s3_bucket" "tfstate" {
  bucket = "${local.name_prefix}-tfstate"
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Owner       = var.owner
    Environment = var.tags.Environment
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_account_public_access_block" "ftstate" {
  block_public_acls = "true"
  ignore_public_acls = "true"
  block_public_policy = "true"
  restrict_public_buckets = "true"
}