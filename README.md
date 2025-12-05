# Apt DevOps Assignment – AWS Terraform One-Click Deployment

This repository contains my solution for the Apt DevOps Backend / DevOps assignment.  
It uses **Terraform** to create a complete AWS environment and deploy a simple web app behind an **Application Load Balancer (ALB)**.

After a successful deploy:

- `http://<ALB_DNS>/` → returns **Hello!**
- `http://<ALB_DNS>/health` → returns **ok**

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

If you want to add an image diagram later, save it as `architecture.png` in the root of this repo and link to it here:

```markdown
![Architecture](./architecture.png)

