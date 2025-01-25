provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demo-server" {
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = "t2.micro"
  key_name = "Devops_Simple"
  subnet_id = aws_subnet.demo-subnet.id
  security_groups = aws_security_group.demo-sg.id
  tags = {
    Name = "demo-server"
    aws_security_group = "demo-sg"
  }
}
resource "aws_security_group" "demo-sg" {
  vpc_id = aws_vpc.demo-vpc.id
  name = "demo-sg"
  tags = {
    Name = "demo-sg"
  }
  description = "Allow inbound traffic"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_vpc" "demo-vpc" {
  tags = {
    Name = "demo-vpc"
  }
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "demo-subnet" {
  tags = {
    Name = "demo-subnet"
  }
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
}
resource "aws_internet_gateway" "demo-igw" {
  tags = {
    Name = "demo-igw"
  }
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "demo-rt" {
  tags = {
    Name = "demo-rt"
  }
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}
resource "aws_route_table_association" "demo-rta" {
  subnet_id = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}