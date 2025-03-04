provider "aws" {
  region = var.aws_region
}

# Fetch available AZs dynamically
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ThreeTierVPC"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "PublicSubnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "PrivateSubnet"
  }
}

# Database Subnet
resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.db_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "DBSubnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "InternetGateway"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for Frontend
resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendSG"
  }
}

# Security Group for RDS
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Restrict access to within the VPC
  }

  tags = {
    Name = "DBSecurityGroup"
  }
}

# EC2 Instance for Frontend
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.frontend_sg.id]
  key_name      = "java"  # Add your key pair here

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to AWS Three-Tier Architecture</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "FrontendServer"
  }
}

# Database Subnet Group for RDS
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "my-db-subnet-group"
  description = "DB Subnet Group for RDS"
  subnet_ids  = [aws_subnet.private_subnet.id, aws_subnet.db_subnet.id]

  tags = {
    Name = "DBSubnetGroup"
  }
}

# RDS Database Instance
resource "aws_db_instance" "db" {
  depends_on            = [aws_db_subnet_group.db_subnet_group]
  identifier            = "mydatabase"
  engine                = "mysql"
  engine_version        = "8.0.36"
  instance_class        = var.db_instance_type
  allocated_storage     = 20
  db_name               = "mydb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name  = "default.mysql8.0"
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]

  tags = {
    Name = "MyDatabase"
  }
}
