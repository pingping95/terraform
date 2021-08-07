// S3 Backend
resource "aws_s3_bucket" "jenkins-test" {
  bucket = "pingping95-jenkins-test"
  versioning {
    enabled = var.s3_versioning
  }

  tags = {
    "Name"        = "pingping95-jenkins-test"
    "Environment" = var.env
  }
}