// 1. Jenkins Role for EC2
resource "aws_iam_role" "jenkins_ec2" {
    name = "Jenkins_EC2_Role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
}

resource "aws_iam_role_policy_attachment" "jenkins_s3_full_access_policy_attachment" {
    role = aws_iam_role.jenkins_ec2.name
    policy_arn = data.aws_iam_policy.S3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "CodeDeploy_full_access_policy_attachment" {
    role = aws_iam_role.jenkins_ec2.name
    policy_arn = data.aws_iam_policy.CodeDeployFullAccess.arn
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "test_profile"
  role = aws_iam_role.jenkins_ec2.name
}


// 2. CodeDeploy Role for EC2
resource "aws_iam_role" "codedeploy_ec2" {
    name = "CodeDeploy_ec2_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
            Service = "ec2.amazonaws.com" // Before : s3.amazonaws.com
            }
        },
        ]
    })
}

resource "aws_iam_role_policy_attachment" "codedeploy_s3_readonly_access_policy_attachment" {
    role = aws_iam_role.codedeploy_ec2.name
    policy_arn = data.aws_iam_policy.S3ReadonlyAccess.arn
}

resource "aws_iam_instance_profile" "codedeploy_profile" {
  name = "CodeDeployRoleProfile"
  role = aws_iam_role.codedeploy_ec2.name
}