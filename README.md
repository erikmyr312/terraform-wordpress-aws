# Terraform WordPress on AWS (VPC + EC2 + RDS)

This project creates AWS infrastructure using Terraform to run WordPress on an EC2 instance and a MySQL database on RDS.

## What it creates
- VPC `wordpress-vpc`
- Internet Gateway `wordpress_igw`
- Public route table `wordpress-rt` (routes 0.0.0.0/0 -> IGW)
- 3 public subnets + 3 private subnets (us-east-1, multi-AZ)
- Security Group `wordpress-sg` (HTTP 80, HTTPS 443, SSH 22 from Internet)
- Security Group `rds-sg` (MySQL 3306 only allowed from `wordpress-sg`)
- Key pair `ssh-key`
- EC2 `wordpress-ec2` (Amazon Linux 2, t2.micro, public subnet)
- RDS MySQL `mysql` (20GB gp2, db.t3.micro) in private subnets via DB subnet group

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform installed
- An existing SSH public key (or create one with `ssh-keygen`)

## How to run
1. Clone the repo:
   ```bash
   git clone git@github.com:erikmyr312/terraform-wordpress-aws.git
   cd terraform-wordpress-aws
