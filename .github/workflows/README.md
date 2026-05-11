## CI/CD

This repository includes GitHub Actions workflows for Terraform.

### Terraform CI

The CI workflow runs on pull requests and pushes to `main`.

It performs:

- `terraform fmt -check`
- `terraform init`
- `terraform validate`
- `terraform plan`

The workflow uses GitHub OIDC to assume an AWS IAM role. No long-lived AWS access keys are stored in GitHub.

### Terraform Apply

The apply workflow is manual and uses `workflow_dispatch`.

To run it:

1. Go to GitHub Actions.
2. Select `Terraform Apply`.
3. Click `Run workflow`.
4. Enter `APPLY` as confirmation.

The workflow then runs:

- `terraform init`
- `terraform validate`
- `terraform plan -out=tfplan`
- `terraform apply tfplan`

### State backend

Terraform state is stored remotely in an S3 bucket with encryption and versioning enabled. DynamoDB is used for state locking.
