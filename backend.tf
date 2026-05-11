terraform {
  backend "s3" {
    bucket       = "terraform-state-eks-lab-305780339972"
    key          = "eks-private-vpc/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}
