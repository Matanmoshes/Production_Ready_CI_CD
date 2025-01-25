########################################
# ALB Security Group
########################################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow inbound HTTP from anywhere"
  vpc_id      = aws_vpc.main.id

  # inbound HTTP from the world on port 80
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all egress or restrict to private subnets
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

########################################
# Ansible SG (public subnet)
########################################
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-sg"
  }
}

########################################
# K8s SG (private subnet)
########################################
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "K8s nodes in private subnet"
  vpc_id      = aws_vpc.main.id

  # SSH from Ansible node (which is in the public subnet)
  ingress {
    description     = "SSH from Ansible node private IP range"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"

    # If your Ansible node is in public_subnet_1, you can reference that subnet's CIDR:
    cidr_blocks     = [aws_subnet.public_subnet_1.cidr_block, aws_subnet.public_subnet_2.cidr_block]
  }

  # Allow all traffic within the K8s SG (control-plane/workers)
  ingress {
    description = "All within group"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Accept traffic from ALB on port 30080 (NodePort)
  # But if you're using hostPort=80 in the Ingress controller, you'd keep port=80
  ingress {
    description    = "NodePort 30080 from ALB"
    from_port      = 30080
    to_port        = 30080
    protocol       = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}
