# Create a key pair for EC2 instance

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "terraform-key"
  public_key = tls_private_key.this.public_key_openssh
  depends_on = [tls_private_key.this]
}

# Create an EC2 instance

resource "aws_instance" "web-instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  key_name                    = aws_key_pair.keypair.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.websubnet.id
  vpc_security_group_ids      = [aws_security_group.web-sg.id]
  user_data                   = file("userdata.sh")
  tags = {
    Name        = "web-instance"
    Environment = "Dev"
  }
  depends_on = [aws_key_pair.keypair, aws_subnet.websubnet, aws_security_group.web-sg]
} 