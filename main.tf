data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  common_tags = {
    Project     = "eks-private-vpc-homework"
    Environment = "learning"
    ManagedBy   = "terraform"
  }
}

data "aws_eks_cluster_auth" "main" {
  name = aws_eks_cluster.main.name
}
