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
# IMPORTANT: Only PUBLIC subnets should be associated to this RT
############################################

resource "aws_route_table" "wordpress_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wordpess-rt"
  }
}

resource "aws_route" "default_internet_route" {
  route_table_id         = aws_route_table.wordpress_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wordpress_igw.id
}

# ------------------------------------------------------------
# Public Subnets
# - map_public_ip_on_launch = true so EC2 gets a public IP
# - spread across 3 AZs for high availability pattern
# ------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "wordpress-public-${count.index + 1}"
  }
}

# ------------------------------------------------------------
# Private Subnets 
# - used for RDS
# - no direct internet route table association
# ------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "wordpress-private-${count.index + 1}"
  }
}

# ------------------------------------------------------------
# Associate ONLY public subnets to the public route table
# Private subnets stay private (no IGW route)
# ------------------------------------------------------------
resource "aws_route_table_association" "public_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.wordpress_rt.id
}

############################################
# WordPress Security Group
# Allows HTTP, HTTPS, SSH from Internet
############################################

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "Allow web and SSH traffic"
  vpc_id      = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}
############################################
# RDS Security Group
# Allows MySQL ONLY from WordPress SG
############################################

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL from WordPress"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}
