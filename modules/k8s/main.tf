# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security group for Ansible Node (Allows HTTP & SSH)
resource "aws_security_group" "k8s_sg" {
  name        = "k8s-security-group"
  description = "Allow HTTP & SSH access for k8s node"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

ingress {
  from_port   = 5789
  to_port     = 5789
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Kubernetes API server
  ingress {
  from_port   = 6443
  to_port     = 6443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# etcd ports (for intra-cluster, use if you add workers later)
  ingress {
  from_port   = 2379
  to_port     = 2380
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
  from_port   = 10250
  to_port     = 10250
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "k8s-master"
  }
}

data "aws_security_group" "k8s_sg" {
  depends_on = [aws_security_group.k8s_sg]
  filter {
    name   = "group-name"
    values = ["k8s-security-group"]
  }
  vpc_id = "vpc-0451179ac74639599"
}

# Ansible Node EC2 Instance
resource "aws_instance" "k8s_master" {
  ami                    = var.ami_id  # AMI ID passed from root module
  instance_type          = var.instance_type
  subnet_id              = "subnet-06885600758b25fde" # Auto-selects default subnet
  vpc_security_group_ids = [data.aws_security_group.k8s_sg.id] # Use SG ID instead of name
  associate_public_ip_address = true  # Ensures Ansible Node is accessible
  key_name               = var.aws_key

  tags = {
    Name = "k8s-master"
  }
}
