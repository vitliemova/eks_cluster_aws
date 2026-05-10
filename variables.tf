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
