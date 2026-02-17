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
# ---------------------------------------------
# Networking (VPC + Subnets)
# ---------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for WordPress VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# 3 AZs in us-east-1
variable "azs" {
  description = "Availability Zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Public subnets (one per AZ)
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Private subnets (one per AZ)
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


# Ports allowed for WordPress EC2
variable "ingress_ports" {
  description = "Ports allowed from the internet to WordPress instance"
  type        = list(number)
  default     = [22, 80, 443]
}

############################################
# RDS settings (simple defaults for the lab)
############################################
variable "db_name" {
  type        = string
  default     = "wordpress"
  description = "Initial database name created in RDS"
}

variable "db_username" {
  type        = string
  default     = "admin"
  description = "RDS master username"
}

variable "db_password" {
  type        = string
  default     = "adminadmin"
  description = "RDS master password (lab only)"
  sensitive   = true
}

variable "db_engine_version" {
  type        = string
  default     = "8.0"
  description = "MySQL engine version"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance size"
}

variable "db_allocated_storage" {
  type        = number
  default     = 20
  description = "RDS storage in GB"
}

variable "db_storage_type" {
  type        = string
  default     = "gp2"
  description = "RDS storage type"
}


############################################
# EC2 Key Pair
# We reference an EXISTING AWS key pair (already created in EC2).
############################################
variable "key_pair_name" {
  description = "Name of an existing EC2 key pair in AWS"
  type        = string
  default     = "ERIKKEY"
}

# variable "ami_id" {
#   description = "Amazon Linux 2 AMI ID"
#   type        = string
# }
