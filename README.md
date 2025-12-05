# Apt DevOps Assignment – AWS Terraform One-Click Deployment

This repository contains my solution for the Apt DevOps Backend / DevOps assignment.  
It uses **Terraform** to create a complete AWS environment and deploy a simple web app behind an **Application Load Balancer (ALB)**.

After a successful deploy:

- `http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/` → returns **Hello!**
- `http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/health` → returns **ok**

---

## Badges

![Terraform](https://img.shields.io/badge/Terraform-1.x-blue?logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange?logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Completed-success)

---

## 1. Architecture (Conceptual)

High-level design:

- **VPC**
  - 2 public subnets (for ALB + NAT)
  - 2 private subnets (for EC2 instances)
- **Internet Gateway** attached to the VPC
- **NAT Gateway** in a public subnet for outbound internet from private subnets
- **Route tables**
  - Public route table → `0.0.0.0/0` via Internet Gateway
  - Private route table → `0.0.0.0/0` via NAT Gateway
- **Security groups**
  - `alb-sg` → allows HTTP (80) from the internet
  - `ec2-sg` → allows TCP 8080 **only** from `alb-sg`
- **Application Layer**
  - Application Load Balancer (ALB) listening on port 80
  - Target group (port 8080) with health check on `/health`
  - Launch template + Auto Scaling Group (ASG) with 2 EC2 instances
  - User data script runs a very simple HTTP server that serves:
    - `Hello!` on `/`
    - `ok` on `/health`


<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/517408c3-6108-4e5f-84b3-47ae2e14f316" />

2. What Terraform Creates
Networking

Custom VPC

2 public subnets

2 private subnets

Internet Gateway

NAT Gateway

Public and private route tables with proper associations

Security

ALB security group (alb-sg)

Inbound: TCP 80 from 0.0.0.0/0

EC2 security group (ec2-sg)

Inbound: TCP 8080 from alb-sg

Load Balancing & Compute

Application Load Balancer (ALB) in public subnets

Target group with health check on /health

Launch template with user data (simple web app)

Auto Scaling Group with desired capacity = 2
(2 EC2 instances in private subnets)

3. Repository Structure
aws-terraform-one-click-deployment/
│
├── project/
│   ├── main.tf            # Root Terraform file
│   ├── vpc.tf             # VPC, subnets, IGW, NAT, route tables
│   ├── security.tf        # Security groups
│   ├── compute.tf         # Launch template, ASG, EC2 details
│   ├── alb.tf             # ALB + target group + listener
│   ├── outputs.tf         # alb_dns output
│   ├── variables.tf       # Input variables
│   └── user-data.sh       # Simple web app (Hello + health)
│
└── README.md


(Names may differ slightly depending on how files are split, but this is the idea.)

4. Prerequisites

AWS account

IAM user with permissions for:

VPC, Subnets, IGW, NAT, Route tables

EC2, Auto Scaling, Launch templates

Elastic Load Balancing

AWS CLI installed and configured:

aws configure
# enter Access Key, Secret Key, region (ap-south-1), output json


Terraform installed (1.x)

5. How to Deploy

All commands are run inside the project/terraform (or project) directory of this repo.

Step 1 – Clone repository

git clone https://github.com/Ravali-951/aws-terraform-one-click-deployment.git
cd aws-terraform-one-click-deployment/project/terraform



Step 2 – Initialize Terraform
terraform init

Step 3 – Review the plan (optional but recommended)
terraform plan

Step 4 – Apply the configuration
terraform apply
# type: yes


When it finishes, Terraform will print the ALB DNS name in the outputs:

alb_dns = "devops-assignment-alb-XXXXXXXX.ap-south-1.elb.amazonaws.com"

6. How to Test

Use the alb_dns output from Terraform.

http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/
  → should respond with:  Hello!

http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/health/
  → should respond with:  ok


These two URLs are required in the assignment instructions.

You can also open them in a browser and take screenshots for submission.

7. Screenshots (for assignment submission)

The following were captured from AWS Console:

VPC list showing devops-assignment-vpc

Subnets (public + private)

Route tables (public + private)

Internet Gateway

NAT Gateway

Security groups (alb-sg and ec2-sg)

Load Balancer with listener and target group

Target Group with Healthy instances

Auto Scaling Group with 2 instances

EC2 instances view (both running)

Browser output:

http://<alb_dns>/ → Hello!

http://<alb_dns>/health → ok

8. Cleanup

To avoid extra AWS charges, destroy everything when you are done:

terraform destroy
# type: yes


This removes all resources created by this configuration.

9. Notes

Region used: ap-south-1 (Mumbai)

Instances: t3.micro (fits in free tier, depending on account)

The project is designed to be simple, readable, and easy to extend (for example, by adding RDS, more services, or CI/CD later).


---

Once you paste this and commit, refresh your GitHub repo page — the README should look:

- Properly aligned
- With clear headings
- With bullet lists and steps
- Easy for the Apt team to understand.



