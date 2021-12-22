// Caller Identity
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
data "aws_partition" "current" {}


// AMI
// 1. Amazon Linux 2
data "aws_ami" "amazon2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}



// Endpoint
// 1. S3
data "aws_vpc_endpoint_service" "s3" {
  service_type = "Interface"
  service      = "s3"
  filter {
    name   = "service-name"
    values = ["*s3*"]
  }
}

// 2. ECR
data "aws_vpc_endpoint_service" "ecr_dkr" {
  service_type = "Interface"
  service      = "ecr.dkr"
  filter {
    name   = "service-name"
    values = ["*ecr.dkr*"]
  }
}


// ACM Certificate
data "aws_acm_certificate" "this" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

// Route 53
data "aws_route53_zone" "pingping2_shop" {
  name = var.domain
}





# // Worker Node Assume Role
# data "aws_iam_policy_document" "managed_workers_role_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

# // OIDC IAM Role Policies

# // AWS Load Balancer Controller Policy
# data "aws_iam_policy_document" "load_balancer_controller" {
#   statement {
#     actions = [
#       "iam:CreateServiceLinkedRole",
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeAddresses",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeInternetGateways",
#       "ec2:DescribeVpcs",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeInstances",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribeTags",
#       "ec2:GetCoipPoolUsage",
#       "ec2:DescribeCoipPools",
#       "elasticloadbalancing:DescribeLoadBalancers",
#       "elasticloadbalancing:DescribeLoadBalancerAttributes",
#       "elasticloadbalancing:DescribeListeners",
#       "elasticloadbalancing:DescribeListenerCertificates",
#       "elasticloadbalancing:DescribeSSLPolicies",
#       "elasticloadbalancing:DescribeRules",
#       "elasticloadbalancing:DescribeTargetGroups",
#       "elasticloadbalancing:DescribeTargetGroupAttributes",
#       "elasticloadbalancing:DescribeTargetHealth",
#       "elasticloadbalancing:DescribeTags"
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "cognito-idp:DescribeUserPoolClient",
#       "acm:ListCertificates",
#       "acm:DescribeCertificate",
#       "acm:GetCertificate",
#       "iam:ListServerCertificates",
#       "iam:GetServerCertificate",
#       "waf-regional:GetWebACL",
#       "waf-regional:GetWebACLForResource",
#       "waf-regional:AssociateWebACL",
#       "waf-regional:DisassociateWebACL",
#       "wafv2:GetWebACL",
#       "wafv2:GetWebACLForResource",
#       "wafv2:AssociateWebACL",
#       "wafv2:DisassociateWebACL",
#       "shield:GetSubscriptionState",
#       "shield:DescribeProtection",
#       "shield:CreateProtection",
#       "shield:DeleteProtection"
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "ec2:CreateSecurityGroup"
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "ec2:CreateTags"
#     ]

#     resources = ["arn:${data.aws_partition.current.partition}:ec2:*:*:security-group/*"]

#     condition {
#       test     = "StringEquals"
#       variable = "ec2:CreateAction"

#       values = [
#         "CreateSecurityGroup",
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "ec2:CreateTags",
#       "ec2:DeleteTags"
#     ]

#     resources = ["arn:${data.aws_partition.current.partition}:ec2:*:*:security-group/*"]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "true",
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:RevokeSecurityGroupIngress",
#       "ec2:DeleteSecurityGroup"
#     ]

#     resources = ["*"]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:CreateLoadBalancer",
#       "elasticloadbalancing:CreateTargetGroup"
#     ]

#     resources = ["*"]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:CreateListener",
#       "elasticloadbalancing:DeleteListener",
#       "elasticloadbalancing:CreateRule",
#       "elasticloadbalancing:DeleteRule"
#     ]
#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]

#     resources = [
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:targetgroup/*/*",
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:loadbalancer/net/*/*",
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:loadbalancer/app/*/*"
#     ]

#     condition {
#       test     = "Null"
#       variable = "aws:RequestTag/elbv2.k8s.aws/cluster"

#       values = [
#         "true",
#       ]
#     }

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:AddTags",
#       "elasticloadbalancing:RemoveTags"
#     ]

#     resources = [
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:listener/net/*/*/*",
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:listener/app/*/*/*",
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
#       "arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
#     ]
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:ModifyLoadBalancerAttributes",
#       "elasticloadbalancing:SetIpAddressType",
#       "elasticloadbalancing:SetSecurityGroups",
#       "elasticloadbalancing:SetSubnets",
#       "elasticloadbalancing:DeleteLoadBalancer",
#       "elasticloadbalancing:ModifyTargetGroup",
#       "elasticloadbalancing:ModifyTargetGroupAttributes",
#       "elasticloadbalancing:DeleteTargetGroup"
#     ]

#     resources = ["*"]

#     condition {
#       test     = "Null"
#       variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"

#       values = [
#         "false",
#       ]
#     }
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:RegisterTargets",
#       "elasticloadbalancing:DeregisterTargets"
#     ]

#     resources = ["arn:${data.aws_partition.current.partition}:elasticloadbalancing:*:*:targetgroup/*/*"]
#   }

#   statement {
#     actions = [
#       "elasticloadbalancing:SetWebAcl",
#       "elasticloadbalancing:ModifyListener",
#       "elasticloadbalancing:AddListenerCertificates",
#       "elasticloadbalancing:RemoveListenerCertificates",
#       "elasticloadbalancing:ModifyRule"
#     ]

#     resources = ["*"]
#   }
# }

# // Cluster Autoscaler Policy
# data "aws_iam_policy_document" "cluster_autoscaler" {
#   statement {
#     actions = [
#       "autoscaling:DescribeAutoScalingGroups",
#       "autoscaling:DescribeAutoScalingInstances",
#       "autoscaling:DescribeLaunchConfigurations",
#       "autoscaling:DescribeTags",
#       "autoscaling:SetDesiredCapacity",
#       "autoscaling:TerminateInstanceInAutoScalingGroup",
#       "ec2:DescribeLaunchTemplateVersions"
#     ]

#     resources = ["*"]
#   }
# }

# // External Secret Policy
# data "aws_iam_policy_document" "external_secrets" {
#   statement {
#     actions = [
#       "secretsmanager:DescribeSecret",
#       "secretsmanager:GetSecretValue",
#       "secretsmanager:ListSecrets",
#       "secretsmanager:ListSecretVersionIds"
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "ssm:DescribeParameters",
#       "ssm:GetParameter",
#       "ssm:GetParameterHistory",
#       "ssm:GetParameters",
#       "ssm:GetParametersByPath"
#     ]

#     resources = ["*"]
#   }
# }

# // External DNS Policy
# data "aws_iam_policy_document" "external_dns" {
#   statement {
#     actions = [
#       "route53:ChangeResourceRecordSets",
#       "route53:ListHostedZones",
#       "route53:ListResourceRecordSets"
#     ]

#     resources = ["*"]
#   }
# }