########################################
# 1) Ansible Control Node (Public Subnet 1)
########################################
resource "aws_instance" "ansible_control" {
  ami                    = var.ami_ubuntu
  instance_type          = var.ansible_instance_type
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = var.key_pair_name
  user_data              = file("${path.module}/ansible-setup.yaml")

  tags = {
    Name = "ansible-control"
  }
}

########################################
# 2) K8s Control Plane Node (Private Subnet)
########################################
resource "aws_instance" "control_plane" {
  ami                    = var.ami_ubuntu
  instance_type          = var.control_plane_instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "control-plane"
  }
}

########################################
# 3) K8s Worker Nodes (Private Subnet)
########################################
resource "aws_instance" "workers" {
  count = var.k8s_worker_count

  ami                    = var.ami_ubuntu
  instance_type          = var.worker_instance_type
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "worker-node-${count.index + 1}"
  }
}
