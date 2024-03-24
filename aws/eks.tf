# data "aws_region" "current" {}

# locals {
#   region = data.aws_region.current.name
# }
# module "vpc" {
#   source                  = "terraform-aws-modules/vpc/aws"
#   name                    = var.vpc_name
#   cidr                    = var.vpc_cidr
#   azs                     = ["${local.region}a", "${local.region}b"]
#   public_subnets          = cidrsubnets(var.vpc_cidr, 1, 1)
#   enable_dns_hostnames    = true
#   enable_dns_support      = true
#   map_public_ip_on_launch = true

#   tags = {
#     Name = var.vpc_name
#   }
#   public_subnet_tags = {
#     Name                                        = "public subnet"
#     "kubernetes.io/role/elb"                    = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
#   }


# }

# resource "aws_iam_role" "eksWorkerNodeRole" {
#   name = "eksWorkerNodeRole"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eksWorkerNodeRole.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eksWorkerNodeRole.name
# }

# resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eksWorkerNodeRole.name
# }

# resource "aws_eks_node_group" "this" {
#   cluster_name    = var.cluster_name
#   node_group_name = "${var.cluster_name}-nodeGroup"
#   node_role_arn   = aws_iam_role.eksWorkerNodeRole.arn
#   subnet_ids      = module.vpc.public_subnets
#   instance_types  = var.instance_types
#   scaling_config {
#     desired_size = var.desired_size
#     max_size     = var.max_size
#     min_size     = var.min_size
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_eks_cluster.this,
#     aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
#   ]
# }

# resource "aws_iam_role" "eksClusterRole" {
#   name = "eksClusterRole"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eksClusterRole.name
# }

# # Optionally, enable Security Groups for Pods
# # Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
# resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eksClusterRole.name
# }

# resource "aws_eks_cluster" "this" {
#   name     = var.cluster_name
#   role_arn = aws_iam_role.eksClusterRole.arn

#   vpc_config {
#     subnet_ids = module.vpc.public_subnets
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
#   ]
# }




