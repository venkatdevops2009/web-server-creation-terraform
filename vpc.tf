# Create a VPC
resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name        = "my-vpc"
    environment = "dev"
  }
}

# Create a subnet

resource "aws_subnet" "websubnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name        = "web-subnet"
    environment = "dev"
  }
  depends_on = [aws_vpc.my-vpc]

}

# Create an internet gateway and attach it to the VPC

resource "aws_internet_gateway" "web-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name        = "web-igw"
    environment = "dev"
  }
  depends_on = [aws_vpc.my-vpc]

}

# Create a route table and associate it with the subnet

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name        = "web-rt"
    environment = "dev"
  }
  depends_on = [aws_vpc.my-vpc]
}

# Create a route to allow internet access from the subnet

resource "aws_route" "web-route" {
  route_table_id         = aws_route_table.web-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web-igw.id
  depends_on             = [aws_internet_gateway.web-igw, aws_route_table.web-rt]
}

# Associate the route table with the subnet

resource "aws_route_table_association" "web-routetable" {
  subnet_id      = aws_subnet.websubnet.id
  route_table_id = aws_route_table.web-rt.id
}

# Create a security group for the web instance

resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.my-vpc.id
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
