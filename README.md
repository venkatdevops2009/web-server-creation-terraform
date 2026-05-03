# Web Server Creation with Terraform

A comprehensive Terraform project that provisions an AWS VPC and a web server (EC2 instance). This project is written in a clear, step-by-step format so anyone can clone the repo and deploy the infrastructure. 

## 🎯 Project Overview

This project uses **Terraform** to provision:
- A custom **VPC** (`10.0.0.0/16`) with a public subnet (`10.0.1.0/24`) in ap-south-1 region
- An **Internet Gateway** and route table for internet access
- A **Security Group** allowing HTTP (port 80) and SSH (port 22)
- An **EC2 instance** (t2.micro) running Apache web server
- An **S3 bucket** for backend state storage
- **TLS private key** and **EC2 key pair** for secure SSH access

---

## 📋 Prerequisites

Before you begin, ensure you have:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.15+
- An [AWS account](https://aws.amazon.com/) with appropriate permissions
- AWS CLI configured with credentials:
  ```bash
  aws configure
  ```
- An AWS profile configured (default profile is used by default)

---

## 📂 Project Structure

```
.
├── backend.tf           # S3 backend configuration for Terraform state
├── provider.tf          # AWS provider configuration (v6.43.0)
├── variables.tf         # Input variables (AMI, instance type, region, etc.)
├── vpc.tf               # VPC, subnet, internet gateway, route table, and security group
├── instance.tf          # EC2 instance, key pair, and TLS private key
├── s3.tf                # S3 bucket creation
├── userdata.sh          # Apache installation and configuration script
└── README.md            # Project documentation
```

---

## ⚙️ Configuration

### Backend Configuration

The Terraform state is stored remotely in an S3 bucket (`backend-9465`) in the `ap-south-1` region with state locking enabled.

```hcl
backend "s3" {
  bucket       = "backend-9465"
  key          = "tf-state"
  region       = "ap-south-1"
  use_lockfile = true
}
```

### Variables

Edit `variables.tf` to customize your deployment:

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `ami` | string | `ami-02eb0c2388ee999f9` | Amazon Linux 2 AMI for ap-south-1 |
| `instance_type` | string | `t2.micro` | EC2 instance type |
| `availability_zone` | string | `ap-south-1a` | AWS availability zone |
| `region` | string | `ap-south-1` | AWS region |
| `aws_profile` | string | `default` | AWS CLI profile to use |
| `vpc_cidr_block` | string | `10.0.0.0/16` | VPC CIDR block |

### Example Customization

```hcl
variable "ami" {
  type    = string
  default = "ami-02eb0c2388ee999f9"  # Amazon Linux 2 in ap-south-1
}

variable "instance_type" {
  type    = string
  default = "t2.micro"  # Free tier eligible
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
```

---

## 🚀 Deployment Steps

### 1. Initialize Terraform

```bash
terraform init
```

This command will:
- Download the AWS provider (v6.43.0)
- Configure the S3 backend for state storage
- Set up the working directory

### 2. Preview the changes

```bash
terraform plan
```

Review the resources that will be created.

### 3. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted to create all resources.

### 4. Retrieve the EC2 Instance Details

After deployment, retrieve the web server IP:

```bash
terraform output
```

The EC2 instance will automatically install and start Apache HTTP Server via the user data script.

### 5. Access the web server

Open a browser and navigate to:

```
http://<EC2-PUBLIC-IP>
```

You should see the welcome message:
```
Welcome to Terraform ! AWS Infra created using Terraform in ap-south-1 Region
```

---

## 🔐 Security & Key Pair Management

- A TLS private key is automatically generated during Terraform apply
- An EC2 key pair named `terraform-key` is created in AWS
- **Important**: Save the generated private key securely for SSH access:
  ```bash
  terraform output -raw tls_private_key_pem > terraform-key.pem
  chmod 400 terraform-key.pem
  ```

### SSH into the EC2 Instance

```bash
ssh -i terraform-key.pem ec2-user@<EC2-PUBLIC-IP>
```

---

## 🌐 Infrastructure Details

### VPC & Networking

- **VPC CIDR**: `10.0.0.0/16`
- **Public Subnet CIDR**: `10.0.1.0/24`
- **Availability Zone**: `ap-south-1a`
- **Internet Gateway**: Attached to VPC for internet access
- **Route Table**: Directs all traffic (`0.0.0.0/0`) to the internet gateway

### Security Group Rules

**Ingress (Inbound):**
- HTTP (Port 80): Open to anywhere (`0.0.0.0/0`)
- SSH (Port 22): Open to anywhere (`0.0.0.0/0`)

**Egress (Outbound):**
- All traffic allowed to anywhere

### EC2 Instance

- **Instance Type**: `t2.micro` (free tier eligible)
- **AMI**: Amazon Linux 2 (`ami-02eb0c2388ee999f9`)
- **Public IP**: Automatically assigned
- **Web Server**: Apache HTTP Server installed via user data script
- **Tags**: 
  - Name: `web-instance`
  - Environment: `Dev`

### S3 Bucket

- **Bucket Name**: `bucket9045`
- **Purpose**: General storage
- **Tags**:
  - Name: `My bucket`
  - Environment: `Dev`

---

## 📝 User Data Script

The `userdata.sh` script runs on EC2 instance startup to configure Apache:

```bash
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo service httpd start  
sudo systemctl enable httpd
echo "<h1>Welcome to Terraform ! AWS Infra created using Terraform in ap-south-1 Region</h1>" > /var/www/html/index.html
```

This script:
1. Updates the system packages
2. Installs Apache HTTP Server (httpd)
3. Starts the Apache service
4. Enables Apache to start on system reboot
5. Creates a simple welcome page

---

## 🛑 Cleanup

To destroy all resources and avoid AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

**Note**: This will delete:
- EC2 instance
- VPC, subnet, internet gateway, and route tables
- Security group
- S3 bucket
- EC2 key pair
- TLS private key

---

## 📊 Terraform Requirements

- **Terraform Version**: `>= 1.15`
- **AWS Provider**: `6.43.0`
- **Language**: HCL (HashiCorp Configuration Language)

---

## 💡 Best Practices Implemented

✅ Remote state management with S3 backend  
✅ State locking for concurrent operation safety  
✅ Proper resource dependencies declared  
✅ Meaningful resource naming and tagging  
✅ Security group with restricted access rules  
✅ Environment separation (Dev/Prod tags)  
✅ Automated EC2 configuration via user data  
✅ Free tier eligible instance type  

---

## ⚠️ Important Notes

- **Costs**: While this uses a free tier eligible instance, AWS charges apply for data transfer and S3 storage. Always destroy resources when not in use.
- **Security**: SSH is open to anywhere (`0.0.0.0/0`). In production, restrict this to your IP address.
- **Region**: This project is configured for `ap-south-1` (Asia Pacific - Mumbai). Modify the `region` variable if you need a different region.
- **State File**: Keep your Terraform state file secure. The S3 backend stores state remotely with locking enabled.
- **Key Pair**: The generated `terraform-key` pair is used for SSH access. Store the private key securely.

---

## 🔗 Useful Commands

```bash
# Initialize Terraform
terraform init

# Format configuration files
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply changes
terraform apply

# Show current state
terraform show

# Destroy infrastructure
terraform destroy

# Get output values
terraform output

# Refresh state
terraform refresh
```

---

## 📜 License

This project is licensed under the **MIT License** - see the LICENSE file for details.

---

## 👤 Author

**venkatdevops2009**

For more information and updates, visit the [GitHub repository](https://github.com/venkatdevops2009/web-server-creation-terraform).

---

## 📞 Support & Troubleshooting

### Common Issues

**Issue**: State lock timeout
- **Solution**: Check if another Terraform operation is running, or manually remove the lock from S3

**Issue**: AMI not found in region
- **Solution**: Verify the AMI ID is correct for your region in `variables.tf`

**Issue**: Security group creation fails
- **Solution**: Ensure your AWS account has VPC permissions

**Issue**: Cannot SSH into EC2
- **Solution**: Verify security group allows SSH (port 22), and use the correct private key with proper permissions (`chmod 400 terraform-key.pem`)

---

**Created**: 2026-05-03  
**Last Updated**: 2026-05-03
