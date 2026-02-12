############################################
# AWS Provider Configuration
# This defines which AWS region Terraform
# will deploy infrastructure into.
############################################

provider "aws" {
  region = var.aws_region
}
