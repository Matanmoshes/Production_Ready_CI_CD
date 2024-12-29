data "aws_availability_zones" "available" {}

########################################
# VPC & Subnets
########################################
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.cluster_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "${var.cluster_name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.cluster_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

########################################
# EKS using terraform-aws-modules/eks v19.x
########################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  vpc_id          = aws_vpc.this.id
  subnet_ids      = concat(
    [for s in aws_subnet.public : s.id],
    [for s in aws_subnet.private : s.id]
  )

  enable_irsa = true

  eks_managed_node_group_defaults = {
    # capacity_type = "ON_DEMAND"
  }

  eks_managed_node_groups = {
    default = {
      desired_capacity = var.desired_size
      max_capacity     = var.max_size
      min_capacity     = var.min_size
      instance_types   = ["t3.micro"]  # KodeKloud limitation
      subnet_ids       = [for s in aws_subnet.private : s.id]
    }
  }

  tags = {
    Environment = "KodeKloud-Playground"
  }
}

########################################
# Kubeconfig Template
########################################
locals {
  kubeconfig_content = templatefile("${path.module}/kubeconfig.tpl", {
    endpoint = module.eks.cluster_endpoint
    ca       = module.eks.cluster_certificate_authority_data
    name     = module.eks.cluster_id
  })
}
