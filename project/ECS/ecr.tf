resource "aws_ecr_repository" "nodejs_app" {
  name = "nodejs_app"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "nodejs_app"
    Environment = var.tags.Environment
  }
}

resource "aws_ecr_lifecycle_policy" "nodejs_app_policy" {
  repository = aws_ecr_repository.nodejs_app.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}