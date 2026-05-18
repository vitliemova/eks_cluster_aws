variable "aws_region" {
  description = "AWS region where the EKS cluster will be created."
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "homework-private-eks"
}

variable "vpc_cidr" {
  description = "Main VPC CIDR."
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version."
  type        = string
  default     = "1.33"
}

variable "enable_github_actions_eks_access" {
  description = "Whether to create EKS access entry for the GitHub Actions IAM role."
  type        = bool
  default     = true
}

variable "github_actions_role_name" {
  description = "IAM role name assumed by GitHub Actions through OIDC."
  type        = string
  default     = "github-actions-terraform-eks-lab-role"
}
