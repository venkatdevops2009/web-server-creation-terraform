# Web Server Creation with Terraform

This project uses **Terraform** to provision:
- A custom **VPC** with a public subnet
- An **Internet Gateway** and route table for internet access
- A **Security Group** allowing HTTP (port 80) and SSH (port 22)
- An **EC2 instance** running a simple Apache web server

---

## 📋 Prerequisites

Before you begin, ensure you have:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.0+
- An [AWS account](https://aws.amazon.com/)
- AWS CLI configured with credentials:
  ```bash
  aws configure
  ```
- An existing AWS key pair for SSH access (or create one in the AWS console)

---

## 📂 Project Structure

```
.
├── backend.tf       # Backend Terraform configuration
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── provider.tf      # AWS provider configuration
├── instance.tf      # EC2 instance creation
├── s3.tf            # S3 Bucket creation
├── vpc.tf           # VPC creation
├── userdata.sh      # Apache installation on Linux server
└── README.md        # Project documentation
```

---

## ⚙️ Configuration

Edit `variables.tf` to customize:

- **region** – AWS region to deploy resources
- **vpc_cidr** – CIDR block for the VPC
- **public_subnet_cidr** – CIDR block for the public subnet
- **instance_type** – EC2 instance type
- **key_name** – Name of your AWS key pair

### Example:

```hcl
variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "my-keypair"
}
```

---

## 🚀 Deployment Steps

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Preview the changes

```bash
terraform plan
```

### 3. Apply the configuration

```bash
terraform apply
```

Type `yes` when prompted.

### 4. Get the public IP

```bash
terraform output web_server_ip
```

### 5. Access the web server

Open a browser and go to:
```
http://<web_server_ip>
```

---

## 🛑 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted.

---

## 📝 Notes

- The EC2 instance runs Apache HTTP Server installed via user_data.
- Security group allows:
  - Port 80 (HTTP) from anywhere
  - Port 22 (SSH) from your IP
- Costs may apply for AWS resources. Always destroy resources when not in use.

---

## 📜 License

This project is licensed under the MIT License.
