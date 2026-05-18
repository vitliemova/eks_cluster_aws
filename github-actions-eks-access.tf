data "aws_caller_identity" "github_actions_account" {}

locals {
  github_actions_role_arn = "arn:aws:iam::${data.aws_caller_identity.github_actions_account.account_id}:role/${var.github_actions_role_name}"
}

resource "aws_eks_access_entry" "github_actions" {
  count = var.enable_github_actions_eks_access ? 1 : 0

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = local.github_actions_role_arn
  type          = "STANDARD"

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-github-actions-access-entry"
  })
}

resource "aws_eks_access_policy_association" "github_actions_cluster_admin" {
  count = var.enable_github_actions_eks_access ? 1 : 0

  cluster_name  = aws_eks_cluster.main.name
  principal_arn = aws_eks_access_entry.github_actions[0].principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}

