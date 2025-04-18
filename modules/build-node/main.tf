# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for Build Node (Allows HTTP & SSH)
resource "aws_security_group" "build_node_sg" {
  name        = "build-node-security-group"
  description = "Allow HTTP & SSH access for Woek node"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows Build Node UI access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Work-Horse-SG"
  }
}

data "aws_security_group" "build_node_sg" {
  depends_on = [aws_security_group.build_node_sg]
  filter {
    name   = "group-name"
    values = ["build-node-security-group"]
  }
  vpc_id = "vpc-090db58e253f5f3fe"
}

# Build Node EC2 Instance
resource "aws_instance" "build_node" {
  ami                    = var.ami_id  # AMI ID passed from root module
  instance_type          = var.instance_type
  subnet_id              = "subnet-03b4224218302cf12" # Auto-selects default subnet
  vpc_security_group_ids = [data.aws_security_group.build_node_sg.id] # Use SG ID instead of name
  associate_public_ip_address = true  # Ensures Build Node is accessible
  key_name               = var.aws_key

  tags = {
    Name = "Work Horse"
  }
}
