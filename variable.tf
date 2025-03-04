variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block for the database subnet"
  default     = "10.0.3.0/24"
}

variable "db_instance_type" {
  description = "Instance type for RDS"
  default     = "db.t3.micro"
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-05b10e08d247fb927"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
  default     = "mypassword"
}
