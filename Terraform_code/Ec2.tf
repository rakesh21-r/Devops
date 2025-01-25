provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "demo-server" {
  ami = "ami-0ac4dfaf1c5c0cce9"
  instance_type = "t2.micro"
  key_name = "Devops_Simple"
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  tags = {
    Name = "demo-server"
    aws_security_group = "demo-sg"
  }
}
resource "aws_security_group" "demo-sg" {
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