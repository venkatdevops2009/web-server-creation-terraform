# Define variables for the AMI, instance type, and availability zone

variable "ami" {
  type    = string
  default = "ami-02eb0c2388ee999f9"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

# Define variable for region
variable "region" {
  type    = string
  default = "ap-south-1"
}

# Define variable for AWS profile
variable "aws_profile" {
  type    = string
  default = "default"
}

# Define variable for VPC CIDR block
variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
