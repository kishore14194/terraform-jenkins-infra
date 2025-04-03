# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for Ansible Node (Allows HTTP & SSH)
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-security-group"
  description = "Allow HTTP & SSH access for Ansible node"
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
    cidr_blocks = ["0.0.0.0/0"]  # Allows Ansible Node UI access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Ansible-SG"
  }
}

data "aws_security_group" "ansible_sg" {
  depends_on = [aws_security_group.ansible_sg]
  filter {
    name   = "group-name"
    values = ["ansible-security-group"]
  }
  vpc_id = "vpc-0451179ac74639599"
}

# Ansible Node EC2 Instance
resource "aws_instance" "ansible_node" {
  ami                    = var.ami_id  # AMI ID passed from root module
  instance_type          = var.instance_type
  subnet_id              = "subnet-06885600758b25fde" # Auto-selects default subnet
  vpc_security_group_ids = [data.aws_security_group.ansible_sg.id] # Use SG ID instead of name
  associate_public_ip_address = true  # Ensures Ansible Node is accessible

  tags = {
    Name = "Ansible Node"
  }
}
