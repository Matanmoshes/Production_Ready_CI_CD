variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "First Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "Second Public subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_1" {
  description = "AZ for the first public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "AZ for the second public subnet"
  type        = string
  default     = "us-east-1b"
}

variable "availability_zone_private" {
  description = "AZ for the private subnet"
  type        = string
  default     = "us-east-1a"
}

variable "my_public_ip" {
  description = "Your public IP with /32 for SSH, e.g. 1.2.3.4/32"
  type        = string
  default     = "81.199.238.79/32"
}

variable "key_pair_name" {
  description = "Name of the existing AWS key pair (created manually)"
  type        = string
  default     = "ansible-key"
}

variable "ami_ubuntu" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-0e2c8caa4b6378d8c" # Ubuntu 24.04
}

variable "ansible_instance_type" {
  description = "Instance type for Ansible control node"
  type        = string
  default     = "t3.medium"
}

variable "control_plane_instance_type" {
  description = "Instance type for K8s control plane"
  type        = string
  default     = "t3.medium"
}

variable "worker_instance_type" {
  description = "Instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "k8s_worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}
