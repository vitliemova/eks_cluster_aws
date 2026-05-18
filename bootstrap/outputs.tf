output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_caller_identity.current.account_id
}

output "terraform_state_bucket_name" {
  description = "Terraform state bucket name."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "github_actions_role_name" {
  description = "IAM role name used by GitHub Actions."
  value       = aws_iam_role.github_actions.name
}

output "github_actions_role_arn" {
  description = "IAM role ARN used by GitHub Actions."
  value       = aws_iam_role.github_actions.arn
}

output "github_actions_oidc_provider_arn" {
  description = "GitHub Actions OIDC provider ARN."
  value       = aws_iam_openid_connect_provider.github_actions.arn
}
