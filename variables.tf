############################################
# Project Variables IMPORTANT 
# All configurable values are defined here
# to keep infrastructure reusable and clean.
############################################

variable "aws_region" {
  description = "AWS region where infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for WordPress VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "ingress_ports" {
  description = "List of allowed inbound ports for WordPress EC2"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
}
