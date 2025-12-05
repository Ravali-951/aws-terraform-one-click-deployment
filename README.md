Apt DevOps Assignment – AWS Terraform Deployment

This repository contains my solution for the Apt Backend DevOps Assignment.
It deploys a web application on AWS using Terraform, VPC, Auto Scaling, and an Application Load Balancer (ALB).

The goal is simple:

Visit http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/
 → shows Hello!

Visit http://ALB-DNS/health
 → shows ok

The goal of the project is to deploy a complete AWS infrastructure using Terraform, along with a simple web application served through an Application Load Balancer (ALB).

The deployment is fully automated and can be executed with a single Terraform command.

1. Overview

The Terraform configuration creates the following:

A custom VPC with public and private subnets

Internet Gateway and NAT Gateway

Route tables for public and private networking

Security groups for ALB and EC2

Launch Template for EC2 instances

Auto Scaling Group running 2 instances across 2 AZs

Application Load Balancer receiving traffic on port 80

A simple HTTP application that returns:

/health → ok

/ → Hello!

After deployment, the application becomes accessible through the ALB DNS name.

2. Architecture Diagram (Text-Based)
                       Internet
                           |
                    Application Load Balancer
                           |
                  -------------------------
                  |                       |
              EC2 Instance            EC2 Instance
              (AZ1, private)         (AZ2, private)
                           |
                     Auto Scaling Group
                           |
                    Launch Template
                           |
                      Private Subnets
                           |
      -------------------------------------------------
      |                                               |
 Public Subnets                                 NAT Gateway
      |                                               |
Internet Gateway  ------------------------------>  Outbound Traffic
                          
                           VPC

3. Terraform Components
VPC and Networking

Custom VPC CIDR: 10.0.0.0/16

2 public subnets for ALB

2 private subnets for EC2 instances

Internet Gateway attached to the VPC

NAT Gateway for EC2 outbound internet connectivity

Public route table routes 0.0.0.0/0 → IGW

Private route table routes 0.0.0.0/0 → NAT Gateway

Security Groups

ALB Security Group

Allows inbound HTTP (80) from anywhere

Allows outbound to EC2 security group

EC2 Security Group

Allows inbound 8080 from ALB SG only

Allows outbound to internet via NAT

Compute Layer

Launch Template

AMI for simple HTTP server

User data to start the app on port 8080

Auto Scaling Group

Desired capacity: 2

Min: 2

Max: 2

Spread across 2 availability zones

Registered with ALB Target Group

Load Balancer

ALB listens on port 80

Forwards traffic to EC2 target group (port 8080)

Health checks on /health

4. Deployment Instructions
Prerequisites

Terraform installed

AWS credentials configured

An AWS account with appropriate permissions

Steps to Deploy

Clone the repository:

git clone https://github.com/Ravali-951/aws-terraform-one-click-deployment
cd aws-terraform-one-click-deployment/project


Initialize Terraform:

terraform init


Apply the configuration:

terraform apply


After a successful apply, Terraform outputs the ALB DNS:

alb_dns = devops-assignment-alb-xxxx.ap-south-1.elb.amazonaws.com


Open in browser:

http://<alb_dns>/ → Hello!

http://<alb_dns>/health → ok

5. Screenshots Included

The screenshots in the assignment folder demonstrate:

VPC

Subnets

Route Tables

Internet Gateway

NAT Gateway

Security Groups

Load Balancer

Target Group

Auto Scaling Group

EC2 Instances

Application output (Hello!, ok)

6. Outputs

Example final output from ALB:

/        → Hello!
/health  → ok


All components deploy correctly, and the application becomes available over the internet through the ALB.

7. Cleanup

To destroy all resources:

terraform destroy
ployment
This project automates the deployment of a secure AWS architecture using Terraform. It includes a VPC, public/private subnets, NAT Gateway, ALB, Auto Scaling Group, and a simple REST API running on port 8080. Supports one-click deploy and destroy scripts.
