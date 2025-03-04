# AWS Three-Tier Architecture with Terraform 🚀

## 📌 Overview

This project sets up a **Three-Tier Architecture** on AWS using Terraform, including:

- **VPC** with Public, Private, and Database subnets
- **EC2 Instance** (Frontend Server with Apache)
- **RDS (MySQL)** for the database
- **Security Groups** for network security
- **Internet Gateway & Route Tables** for connectivity

---

## 🔧 Setup Instructions

### **1️⃣ Prerequisites**

- Install Terraform: [Download](https://www.terraform.io/downloads)
- Install AWS CLI: [Download](https://aws.amazon.com/cli/)
- Configure AWS Credentials:
  ```bash
  aws configure
  ```

### **2️⃣ Clone the Repository**

```bash
git clone https://github.com/your-username/aws-three-tier-terraform.git
cd aws-three-tier-terraform
```

### **3️⃣ Initialize Terraform**

```bash
terraform init
```

### **4️⃣ Validate Terraform Configuration**

```bash
terraform validate
```

### **5️⃣ Apply the Terraform Configuration**

```bash
terraform apply -auto-approve
```

This will create all AWS resources.

---

## ✅ **Verification**

1. Get the Public IP of the EC2 instance:
   ```bash
   terraform output frontend_public_ip
   ```
2. Open the browser and go to:
   ```
   http://<your-ec2-public-ip>
   ```
   You should see:
   ```
   Welcome to AWS Three-Tier Architecture
   ```

---

## ⚠️ **Issues Faced & Fixes**

### **1. EC2 Instance Not Reachable (Connection Timeout)**

✔️ **Fix:** Ensure the security group allows **HTTP (port 80) and SSH (port 22) inbound**.

```bash
echo "Checking Security Groups..."
aws ec2 describe-security-groups --region us-east-1 --group-ids <your-security-group-id>
```

### **2. Apache Not Running on EC2**

✔️ **Fix:** Run the following commands manually:

```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
```

### **3. RDS Database Creation Error**

✔️ **Fix:** Ensure the **DBSubnetGroup exists** before deploying.

```bash
aws rds describe-db-subnet-groups --region us-east-1
```

### **4. Terraform Errors (Invalid Instance Type)**

✔️ **Fix:** Ensure correct **instance types** are used:

- `db.t3.micro` (for RDS)
- `t2.micro` or `t3.micro` (for EC2)

---

## 📝 **Manual Steps If User Data Fails**

If the Apache web server doesn’t start automatically, you can manually create the **index.html** file:

```bash
sudo su -
echo "<h1>Welcome to AWS Three-Tier Architecture</h1>" > /var/www/html/index.html
sudo systemctl restart httpd
```

---

## 📌 **Destroy Resources (Cleanup)**

To delete all AWS resources:

```bash
terraform destroy -auto-approve
```

---

## 📜 **License**

This project is **open-source** and available for use.

---

## 📌 **Next Steps**

- Add **Load Balancer** for high availability
- Implement **Auto Scaling** for better performance
- Use **AWS Secrets Manager** for database credentials

🚀 **Happy Terraforming!**

# Three-Tier Architecture with Terraform on AWS

## Introduction
This project implements a **Three-Tier Architecture** using **Terraform** to provision infrastructure on **AWS**. It follows best practices for **scalability, security, and high availability** by separating resources into three layers:

1. **Presentation Layer (Frontend) - Web Servers & Load Balancer**
2. **Application Layer (Backend) - App Servers**
3. **Database Layer - RDS (Relational Database Service)**

---

## Project Architecture

### **1️⃣ Presentation Layer (Frontend)**
- **Purpose:** Serves static content and handles incoming traffic.
- **AWS Services:**
  - **Elastic Load Balancer (ALB)** - Distributes traffic across instances.
  - **Auto Scaling Group (ASG)** - Ensures high availability.
  - **EC2 Instances** - Web servers running Apache/NGINX.
  - **Public Subnet** - Web servers are accessible from the internet.

### **2️⃣ Application Layer (Backend)**
- **Purpose:** Processes business logic and API requests.
- **AWS Services:**
  - **EC2 Instances** - Runs backend services (Node.js, Python, Java, etc.).
  - **Auto Scaling Group (ASG)** - Scales based on demand.
  - **Security Group** - Restricts access to only frontend requests.
  - **Private Subnet** - No direct internet access.

### **3️⃣ Database Layer**
- **Purpose:** Stores and manages application data securely.
- **AWS Services:**
  - **Amazon RDS** (MySQL/PostgreSQL) - Managed database service.
  - **Database Subnet Group** - Provides high availability.
  - **Private Subnet** - No direct internet access.
  - **Security Group** - Only allows connections from the application layer.

---

## Infrastructure Setup Using Terraform
### **1️⃣ Terraform Variables (Reusable Configuration)**
```hcl
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}
```

### **2️⃣ VPC & Subnets**
```hcl
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
}
```

### **3️⃣ Load Balancer & Auto Scaling Group**
```hcl
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets           = [aws_subnet.public_subnet.id]
}
```

### **4️⃣ Database Setup**
```hcl
resource "aws_db_instance" "db" {
  engine         = "mysql"
  instance_class = "db.t3.micro"
  username      = "admin"
  password      = "mypassword"
  db_subnet_group_name = aws_subnet.private_subnet.id
}
```

---

## How to Deploy
1. **Install Terraform**: [Download Terraform](https://www.terraform.io/downloads)
2. **Initialize Terraform**:
   ```sh
   terraform init
   ```
3. **Plan the Deployment**:
   ```sh
   terraform plan
   ```
4. **Apply the Configuration**:
   ```sh
   terraform apply -auto-approve
   ```
5. **Access the Load Balancer**:
   - Run `terraform output` to get the ALB DNS name.
   - Open it in a browser to check the frontend.

---

## Clean Up Resources
To delete all AWS resources created by Terraform:
```sh
terraform destroy -auto-approve
```

---

## Benefits of This Architecture
✅ **High Availability** - Auto Scaling & Load Balancer ensure uptime.  
✅ **Security** - Private subnets for backend & database.  
✅ **Scalability** - Auto Scaling dynamically adjusts resources.  
✅ **Cost Efficiency** - Resources are provisioned on demand.  

---

## Next Steps
- Implement **IAM roles** for secure access.
- Add **monitoring & logging** (CloudWatch, AWS Config).
- Automate with **CI/CD pipelines**.

🚀 **Deploy your scalable AWS application today!**


