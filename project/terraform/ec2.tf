# ec2.tf - launch template + auto scaling group

# 1) Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

# 2) Launch template for EC2 instances
resource "aws_launch_template" "app_lt" {
  name_prefix   = "devops-assignment-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # user_data = startup script that runs on every EC2
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y git python3-pip

    cd /home/ec2-user
    # clone your repo
    git clone https://github.com/Ravali-951/aws-terraform-one-click-deployment.git

    cd aws-terraform-one-click-deployment/project/app
    pip3 install flask

    # run the Flask app on port 8080 in background
    nohup python3 main.py > app.log 2>&1 &
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "devops-assignment-ec2"
    }
  }
}

# 3) Auto Scaling Group using the launch template
resource "aws_autoscaling_group" "app_asg" {
  name             = "devops-assignment-asg"
  min_size         = 2
  max_size         = 2
  desired_capacity = 2

  # private subnets
  vpc_zone_identifier = aws_subnet.private[*].id

  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "devops-assignment-ec2"
    propagate_at_launch = true
  }

  # make sure ALB listener exists first
  depends_on = [aws_lb_listener.app_listener]
}
