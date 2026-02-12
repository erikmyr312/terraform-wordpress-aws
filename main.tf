############################################
##############     VPC    ###################
# Main network container for WordPress infrastructure
############################################

resource "aws_vpc" "wordpress_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "wordpress-vpc"
  }
}

############################################
# Internet Gateway
# Enables internet access for public subnets
############################################

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wordpress-igw"
  }
}


############################################
# Public Route Table
# Routes outbound traffic to Internet Gateway
############################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }

  tags = {
    Name = "wordpress-public-rt"
  }
}
