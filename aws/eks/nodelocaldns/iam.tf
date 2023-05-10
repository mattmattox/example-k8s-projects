// Kubernetes cluster permissions
resource "aws_iam_policy" "eks_worker_permissions" {
  name        = "${var.environment}-eks-worker-policy"
  description = "Worker policy for ECR, EFS, and S3."

  policy = data.aws_iam_policy_document.eks_worker_permissions.json
}

// Kubernetes cluster permissions (IAM policy document)
data "aws_iam_policy_document" "eks_worker_permissions" {

  // Required for EKS workers to pull ECR container images
  statement {
    sid    = "AllowEKSWorkersToECR"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  // Required for EKS workers to pull all ECR container images
  statement {
    sid    = "AllowEKSWorkersToECRDEBUG"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  // Required for cluster autoscaler. TODO (@adysart): migrate to IRSA and scope down
  statement {
    sid    = "AllowEKSNodesToEC2LaunchTemplates"
    effect = "Allow"
    actions = [
      "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = [
      "*"
    ]
  }

  // Required for cluster autoscaler. TODO (@adysart): migrate to IRSA and scope down
  statement {
    sid    = "AllowEKSNodesToEC2AutoScalingGroups"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
    resources = [
      "*"
    ]
  }

}