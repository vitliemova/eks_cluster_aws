### Workflows

| Workflow | Trigger | Purpose |
|---|---|---|
| Terraform CI | Push / Pull Request | Format, validate and plan Terraform changes |
| Terraform Apply | Manual | Apply Terraform changes after explicit confirmation |
| Ansible Validate EKS | Manual | Validate the deployed EKS environment and upload a validation report |

### Terraform CI
This repository includes GitHub Actions workflows for Terraform.

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

###Ansible Validate EKS

The Ansible validation workflow is manual and is intended to be run after Terraform has provisioned or updated the environment.

To run it:

GitHub → Actions → Ansible Validate EKS → Run workflow

The workflow requires confirmation input:

VALIDATE

It performs:

Configure AWS credentials through GitHub OIDC
Install kubectl
Install Ansible
Update kubeconfig for the EKS cluster
Run ansible-playbook ansible/validate_terraform_eks.yml
Upload validation-report.md as a GitHub Actions artifact
