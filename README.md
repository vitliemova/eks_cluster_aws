# EKS on Private VPC with Terraform

## Objective

Provision an Amazon EKS cluster in private subnets with controlled outbound access using Terraform.

The solution creates:

- VPC with CIDR `10.0.0.0/16`
- 2 Availability Zones
- 2 public subnets
- 2 private subnets
- Internet Gateway for public subnet internet access
- 1 NAT Gateway for private subnet outbound access
- Managed EKS cluster
- Managed node group deployed only in private subnets
- No public IP assignment for worker nodes
- Kubernetes subnet tags for load balancer discovery
- AWS Load Balancer Controller
- Internal AWS Load Balancer for the sample application
- VPC endpoints for selected AWS services

## Architecture

```text
VPC: 10.0.0.0/16

Public Subnets:
├── public-1
│   └── NAT Gateway
└── public-2

Private Subnets:
├── private-1
│   ├── EKS worker nodes
│   └── VPC interface endpoints
└── private-2
    ├── EKS worker nodes
    └── VPC interface endpoints

Private subnet default route:
0.0.0.0/0 -> NAT Gateway

Worker nodes are launched only in private subnets. The private subnets have map_public_ip_on_launch = false, so EC2 worker nodes do not receive public IP addresses.

Prerequisites

Install:

Terraform >= 1.6
AWS CLI v2
kubectl
Helm
Git

AWS permissions required:

VPC
EC2 networking
IAM roles and policies
EKS
VPC endpoints
Elastic Load Balancing

Configure AWS credentials:

</> Bash
aws configure

Project structure
.
├── versions.tf
├── variables.tf
├── main.tf
├── vpc.tf
├── iam.tf
├── eks.tf
├── endpoints.tf
├── load-balancer-controller.tf
├── outputs.tf
├── terraform.tfvars
├── aws-load-balancer-controller-iam-policy.json
├── README.md
└── k8s/
    ├── namespace.yaml
    ├── nginx-html-configmap.yaml
    ├── nginx-deployment.yaml
    └── nginx-internal-lb.yaml

Deployment

Initialize Terraform:
</> Bash
terraform init

Format and validate:

terraform fmt -recursive
terraform validate

Review the plan:
terraform plan

Deploy:
terraform apply

After deployment, configure kubectl:
aws eks update-kubeconfig \
  --region eu-central-1 \
  --name homework-private-eks

Verify cluster nodes:
kubectl get nodes -o wide

Deploy sample application
Apply the Kubernetes manifests:
kubectl apply -f k8s/

Check pods:

kubectl get pods -n private-demo -o wide

Check service:

kubectl get svc -n private-demo

The application is exposed using an internal AWS Load Balancer.

Validation:
1. Validate nodes are private, Ready, Node internal IPs are from private subnet ranges:

10.0.10.0/24
10.0.11.0/24

kubectl get nodes -o wide
NAME                                           STATUS   ROLES    AGE   VERSION                INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                        KERNEL-VERSION                    CONTAINER-RUNTIME
ip-10-0-10-157.eu-central-1.compute.internal   Ready    <none>   19h   v1.33.11-eks-4136f65   10.0.10.157   <none>        Amazon Linux 2023.11.20260505   6.12.80-106.156.amzn2023.x86_64   containerd://2.2.3+unknown
ip-10-0-11-242.eu-central-1.compute.internal   Ready    <none>   19h   v1.33.11-eks-4136f65   10.0.11.242   <none>        Amazon Linux 2023.11.20260505   6.12.80-106.156.amzn2023.x86_64   containerd://2.2.3+unknown

2. Validate pods are scheduled on private nodes
kubectl get pods -n private-demo -o wide
NAME                     READY   STATUS    RESTARTS   AGE   IP            NODE                                           NOMINATED NODE   READINESS GATES
nginx-55464cdb5d-tjpfl   1/1     Running   0          18h   10.0.10.43    ip-10-0-10-157.eu-central-1.compute.internal   <none>           <none>
nginx-55464cdb5d-vrqxd   1/1     Running   0          18h   10.0.11.146   ip-10-0-11-242.eu-central-1.compute.internal   <none>           <none>

3. Validate EC2 worker nodes have no public IP
aws ec2 describe-instances \
  --filters "Name=tag:eks:cluster-name,Values=homework-private-eks" \
  --query "Reservations[*].Instances[*].[InstanceId,PrivateIpAddress,PublicIpAddress,SubnetId,State.Name]" \
  --output table
---------------------------------------------------------------------------------------
|                                  DescribeInstances                                  |
+----------------------+--------------+-------+----------------------------+----------+
|  i-0096809a757fbde92 |  10.0.11.242 |  None |  subnet-0d1db583d8f4bb43c  |  running |
|  i-025d738531d1f23ad |  10.0.10.157 |  None |  subnet-0bad01533105c74d8  |  running |
+----------------------+--------------+-------+----------------------------+----------+

4. Validate internal LoadBalancer
kubectl get svc nginx-internal -n private-demo
NAME             TYPE           CLUSTER-IP       EXTERNAL-IP                                                                        PORT(S)        AGE
nginx-internal   LoadBalancer   172.20.214.128   k8s-privated-nginxint-67e11a903b-57d249bc3d696ff8.elb.eu-central-1.amazonaws.com   80:30388/TCP   20m

Check AWS Load Balancer scheme:
aws elbv2 describe-load-balancers \
  --query "LoadBalancers[*].[LoadBalancerName,Scheme,DNSName,VpcId]" \
  --output table
---------------------------------------------------------------------------------------------------------------------------------------------------------------
|                                                                    DescribeLoadBalancers                                                                    |
+----------------------------------+-----------+------------------------------------------------------------------------------------+-------------------------+
|  k8s-privated-nginxint-67e11a903b|  internal |  k8s-privated-nginxint-67e11a903b-57d249bc3d696ff8.elb.eu-central-1.amazonaws.com  |  vpc-02d9f8452c1113c49  |
+----------------------------------+-----------+------------------------------------------------------------------------------------+-------------------------+

5. Validate application response
kubectl run curl-test \
  --namespace private-demo \
  --image=curlimages/curl:latest \
  --rm -i \
  --restart=Never \
  -- sh -c "curl -s http://nginx-internal.private-demo.svc.cluster.local | grep 'Добре дошъл' | sed 's/<[^>]*>//g' | xargs"
Добре дошъл в света на Kubernetes
pod "curl-test" deleted from private-demo namespace

6. VPC Endpoints
The solution includes VPC endpoints for:

S3 Gateway Endpoint
ECR API Interface Endpoint
ECR Docker Interface Endpoint
SSM Interface Endpoint
SSM Messages Interface Endpoint
EC2 Messages Interface Endpoint

Validate endpoints:
aws ec2 describe-vpc-endpoints \
  --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" \
  --query "VpcEndpoints[*].[VpcEndpointId,ServiceName,VpcEndpointType,State]" \
  --output table
------------------------------------------------------------------------------------------------
|                                     DescribeVpcEndpoints                                     |
+-------------------------+------------------------------------------+------------+------------+
|  vpce-0de2c0df3f2bba50d |  com.amazonaws.eu-central-1.s3           |  Gateway   |  available |
|  vpce-0179a99921a013b24 |  com.amazonaws.eu-central-1.ssm          |  Interface |  available |
|  vpce-008cbf3a768bbb4a5 |  com.amazonaws.eu-central-1.ecr.api      |  Interface |  available |
|  vpce-0bb5b9632c1a03540 |  com.amazonaws.eu-central-1.ec2messages  |  Interface |  available |
|  vpce-0f68ab34a959c2b20 |  com.amazonaws.eu-central-1.ssmmessages  |  Interface |  available |
|  vpce-01aba485378e4182a |  com.amazonaws.eu-central-1.ecr.dkr      |  Interface |  available |
+-------------------------+------------------------------------------+------------+------------+

Security notes
Worker nodes are deployed only in private subnets.
Worker nodes do not receive public IP addresses.
Public subnets are used for NAT Gateway and load balancer discovery.
Private subnets are tagged for internal load balancer discovery.
Security groups separate EKS control plane, nodes, and VPC endpoints.
AWS Load Balancer Controller uses IRSA instead of static AWS credentials.
Node group IAM role uses AWS managed policies required for EKS worker nodes, CNI, ECR read-only access, and SSM access.

Cleanup

Delete Kubernetes resources:
kubectl delete -f k8s/

Destroy infrastructure:
terraform destroy
