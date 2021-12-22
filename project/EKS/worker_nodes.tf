// 1. Managed Node groups
resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.name_prefix}-worker-node"
  node_role_arn   = aws_iam_role.managed_worker.arn
  subnet_ids      = module.main_vpc.private_subnets_ids

  // Worker Settings
  instance_types = var.worker_instance_types
  disk_size      = var.worker_disk_size

  scaling_config {
    desired_size = var.worker_size.desired
    min_size     = var.worker_size.min
    max_size     = var.worker_size.max
  }

  remote_access {
    source_security_group_ids = [aws_security_group.common_ssh.id]
    ec2_ssh_key               = var.key_pair
  }

  tags = {
    Name        = "${local.name_prefix}-worker-node"
    Environment = "${var.tags.Environment}"
    Owner = var.owner_tag
  }

  # IAM Role이 생성된 이후 Worker Node를 생성하도록 의존 관계 설정
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}

// Worker Node를 위한 IAM Role 생성
resource "aws_iam_role" "managed_worker" {
  name               = "${local.name_prefix}-managed-worker-node"
  assume_role_policy = data.aws_iam_policy_document.managed_workers_role_assume_role_policy.json
  tags = {
    Environment = "${var.tags.Environment}"
    Owner = var.owner_tag
  }
}

// IAM Role에 Policy를 Attach하는 작업
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.managed_worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.managed_worker.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.managed_worker.name
}