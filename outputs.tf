output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "selected_availability_zones" {
  description = "The two Availability Zones selected for this deployment."
  value       = local.azs
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID."
  value       = aws_nat_gateway.main.id
}

output "public_route_table_id" {
  description = "Public route table ID."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID."
  value       = aws_route_table.private.id
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster."
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_group_role_arn" {
  description = "IAM role ARN for the EKS managed node group."
  value       = aws_iam_role.eks_node_group.arn
}

output "eks_cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint."
  value       = aws_eks_cluster.main.endpoint
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_security_group_id" {
  description = "EKS nodes security group ID."
  value       = aws_security_group.eks_nodes.id
}

output "update_kubeconfig_command" {
  description = "Command to configure kubectl."
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

output "eks_node_group_name" {
  description = "EKS managed node group name."
  value       = aws_eks_node_group.private.node_group_name
}

output "eks_node_group_status" {
  description = "EKS managed node group status."
  value       = aws_eks_node_group.private.status
}

output "s3_vpc_endpoint_id" {
  description = "S3 Gateway VPC endpoint ID."
  value       = aws_vpc_endpoint.s3.id
}

output "ecr_api_vpc_endpoint_id" {
  description = "ECR API Interface VPC endpoint ID."
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_vpc_endpoint_id" {
  description = "ECR Docker Interface VPC endpoint ID."
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "ssm_vpc_endpoint_id" {
  description = "SSM Interface VPC endpoint ID."
  value       = aws_vpc_endpoint.ssm.id
}
