variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "eu-central-1"
}

variable "github_owner" {
  description = "GitHub user or organization that owns the repository."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
}

variable "github_actions_role_name" {
  description = "IAM role name assumed by GitHub Actions through OIDC."
  type        = string
  default     = "github-actions-terraform-eks-lab-role"
}

variable "terraform_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state."
  type        = string
}
