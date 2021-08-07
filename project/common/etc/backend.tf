// S3 Backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "pingping95-tfstate-bucket"
  versioning {
    enabled = var.s3_versioning
  }

  tags = {
    "Name"        = "pingping95-tfstate-bucket"
    "Environment" = var.env
  }
}

// DynamoDB for terraform state Lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}