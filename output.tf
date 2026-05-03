# Define outputs for the public IP address of the EC2 instance, S3 bucket name, VPC ID, subnet ID, security group ID, and key pair name

output "public-ip-address" {
  value = aws_instance.web-instance.public_ip
}

output "bucket-name" {
  value = aws_s3_bucket.bucket.bucket
}

output "vpc-id" {
  value = aws_vpc.my-vpc.id
}

output "subnet-id" {
  value = aws_subnet.websubnet.id
}

output "security-group-id" {
  value = aws_security_group.web-sg.id
}

output "key-pair-name" {
  value = aws_key_pair.keypair.key_name
}