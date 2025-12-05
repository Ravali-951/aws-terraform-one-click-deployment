Apt DevOps Assignment – AWS Terraform Deployment

This project is my solution for the Apt DevOps Backend Assignment.
It deploys a web application on AWS using Terraform, VPC, Auto Scaling, and an Application Load Balancer (ALB).

The goal is simple:

Visit http://devops-assignment-alb-914552625.ap-south-1.elb.amazonaws.com/
 → shows Hello!

Visit http://ALB-DNS/health
 → shows ok

🚀 What This Project Builds

Terraform automatically creates the entire AWS infrastructure:

1️⃣ Network Setup (VPC)

Custom VPC

2 Public Subnets

2 Private Subnets

Internet Gateway (IGW)

NAT Gateway

Public & Private Route Tables

2️⃣ Security

ALB Security Group → Allows HTTP from anywhere

EC2 Security Group → Allows port 8080 only from ALB

3️⃣ Load Balancing + Compute

Application Load Balancer (ALB)

Target Group with health check on /health

Launch Template with user data (simple web app)

Auto Scaling Group (ASG) → runs 2 EC2 instances

🏗️ Terraform File Structure
terraform/
├── main.tf         → ALB, ASG, Launch Template
├── vpc.tf          → VPC, Subnets, Gateways, Routes
├── security.tf     → Security Groups
├── outputs.tf      → Prints ALB DNS name
└── user_data.sh    → Simple web app (Hello + health)

📥 How to Deploy
Step 1 — Clone the repository
git clone https://github.com/Ravali-951/aws-terraform-one-click-deployment.git
cd aws-terraform-one-click-deployment/project/terraform

Step 2 — Configure AWS CLI
aws configure

Step 3 — Initialize Terraform
terraform init

Step 4 — Apply the infrastructure
terraform apply


Wait a few minutes…

Terraform will show:

Apply complete!
alb_dns = "devops-assignment-alb-xxxxx.ap-south-1.elb.amazonaws.com"

🧪 How to Test

Replace <ALB-DNS> with your output.

✔ Check Main Endpoint
http://<ALB-DNS>/


Expected:

Hello!

✔ Check Health Endpoint
http://<ALB-DNS>/health


Expected:

ok

📸 Screenshots Included

I have added screenshots for:

Terraform Apply

Terraform Output

VPC

Subnets

Route Tables

Internet Gateway

NAT Gateway

Security Groups

ALB

Target Group (Healthy)

Auto Scaling Group

EC2 Instances

Browser Output (Hello + ok)

🧹 Cleanup

To avoid AWS charges:

terraform destroy



# aws-terraform-one-click-deployment
This project automates the deployment of a secure AWS architecture using Terraform. It includes a VPC, public/private subnets, NAT Gateway, ALB, Auto Scaling Group, and a simple REST API running on port 8080. Supports one-click deploy and destroy scripts.
