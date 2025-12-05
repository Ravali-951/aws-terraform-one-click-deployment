# alb.tf - Application Load Balancer configuration

# ---------------------------------------------
# 1. Create the ALB
# ---------------------------------------------
resource "aws_lb" "app_alb" {
  name               = "devops-assignment-alb"
  load_balancer_type = "application"
  subnets            = aws_subnet.public[*].id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "devops-assignment-alb"
  }
}

# ---------------------------------------------
# 2. Target Group (EC2 Instances)
# ---------------------------------------------
resource "aws_lb_target_group" "app_tg" {
  name     = "devops-assignment-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = "8080"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "devops-assignment-target-group"
  }
}

# ---------------------------------------------
# 3. Listener (forward HTTP → EC2 target group)
# ---------------------------------------------
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
