data "aws_iam_policy" "S3FullAccess" {
    arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "CodeDeployFullAccess" {
    arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

data "aws_iam_policy" "S3ReadonlyAccess" {
    arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}