variable "ami_id" {
  description = "AMI ID for Build Node instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"  # Change based on your requirement
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "aws_key" {
  description = "Key to use"
  type        = string
  default     = "ec2-demo"
}