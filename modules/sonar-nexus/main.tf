# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for sonar-nexus Node (Allows HTTP & SSH)
resource "aws_security_group" "sonar_nexus_sg" {
  name        = "sonar-nexus-security-group"
  description = "Allow HTTP & SSH access for sonar-nexus"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Nexus web interface (Admin Console).
  }

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Optional: Other Nexus services or proxy configurations.
  }

  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # If using Nexus as a Docker registry.
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SonarQube web interface.
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Optional: SonarQube background process communication.
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

data "aws_security_group" "sonar_nexus_sg" {
  depends_on = [aws_security_group.sonar_nexus_sg]
  filter {
    name   = "group-name"
    values = ["sonar-nexus-security-group"]
  }
  vpc_id = "vpc-090db58e253f5f3fe"
}

#  sonar nexus EC2 Instance
resource "aws_instance" "sonar_nexus_node" {
  ami                    = var.ami_id  # AMI ID passed from root module
  instance_type          = var.instance_type
  subnet_id              = "subnet-03b4224218302cf12" # Auto-selects default subnet
  vpc_security_group_ids = [data.aws_security_group.sonar_nexus_sg.id] # Use SG ID instead of name
  associate_public_ip_address = true  # Ensures sonar-nexus is accessible
  key_name               = var.aws_key

  tags = {
    Name = "sonar-nexus"
  }
}
