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

