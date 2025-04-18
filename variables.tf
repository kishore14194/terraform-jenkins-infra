# AWS Region
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

# AMI ID for EC2 Instances
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

# Instance Type
variable "instance_type" {
  description = "Instance type for Jenkins and build nodes"
  type        = string
  default     = "t2.medium"
}

# Instance Type
variable "k8_instance_type" {
  description = "Instance type for Jenkins and build nodes"
  type        = string
  default     = "t2.medium"
}