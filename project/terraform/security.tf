# security.tf - security groups for ALB and EC2 instances

# 1) Security group for the Load Balancer (public http)
resource "aws_security_group" "alb_sg" {
  name        = "devops-assignment-alb-sg"
  description = "Allow HTTP from anywhere to ALB"
  vpc_id      = aws_vpc.main.id

  # Allow HTTP (port 80) from anyone on the internet
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
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

# 2) Security group for EC2 instances (only ALB can talk to them)
resource "aws_security_group" "ec2_sg" {
  name        = "devops-assignment-ec2-sg"
  description = "Allow app traffic from ALB only"
  vpc_id      = aws_vpc.main.id

  # Allow app port (8080) only from the ALB security group
  ingress {
    description              = "App traffic from ALB"
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    security_groups          = [aws_security_group.alb_sg.id]
  }

  # (Optional) Uncomment this if you ever want SSH from your own IP
  # ingress {
  #   description = "SSH from my IP"
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["YOUR.IP.ADDR.123/32"]
  # }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}
