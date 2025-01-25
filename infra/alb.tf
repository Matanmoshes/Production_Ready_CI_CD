########################################
# ALB Setup
########################################

# 1) Create the ALB
resource "aws_lb" "http_alb" {
  name               = "k8s-application"
  load_balancer_type = "application"

  # MUST have at least 2 subnets in 2 different AZs
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  security_groups    = [aws_security_group.alb_sg.id]

  idle_timeout              = 30
  enable_deletion_protection = false

  tags = {
    Name = "k8s-http-alb"
  }
}

# 2) Create the Target Group on port 30080 (NodePort)
resource "aws_lb_target_group" "tg" {
  name        = "k8s-worker-tg"
  port        = 30080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    port     = "30080"
    path     = "/healthcheck"
    matcher  = "200"
  }

  tags = {
    Name = "k8s-http-tg"
  }
}

# 3) Attach each worker instance to the TG
resource "aws_lb_target_group_attachment" "workers" {
  count            = length(aws_instance.workers[*].id)
  target_group_arn = aws_lb_target_group.tg.arn
  port             = 30080
  target_id        = aws_instance.workers[count.index].id
}

# 4) Create the Listener on port 80 (public side)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.http_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
