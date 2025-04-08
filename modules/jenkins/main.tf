# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch a default subnet in the default VPC
# data "aws_subnet" "default" {
#   vpc_id = data.aws_vpc.default.id
# }

# Security group for Jenkins (Allows HTTP & SSH)
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow HTTP & SSH access for Jenkins"
  vpc_id      = data.aws_vpc.default.id
  # subnet_id   = "subnet-06885600758b25fde"

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
    cidr_blocks = ["0.0.0.0/0"]  # Allows Jenkins UI access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-SG"
  }
}

data "aws_security_group" "jenkins_sg" {
  depends_on = [aws_security_group.jenkins_sg]
  filter {
    name   = "group-name"
    values = ["jenkins-security-group"]
  }
  vpc_id = "vpc-0451179ac74639599"
}

# Jenkins EC2 Instance
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id  # AMI ID passed from root module
  instance_type          = var.instance_type
  subnet_id              = "subnet-06885600758b25fde" # Auto-selects default subnet
  vpc_security_group_ids = [data.aws_security_group.jenkins_sg.id] # Use SG ID instead of name
  associate_public_ip_address = true  # Ensures Jenkins is accessible
  key_name               = var.aws_key

  tags = {
    Name = "Jenkins Master"
  }
}
