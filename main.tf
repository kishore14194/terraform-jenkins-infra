terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region  # Change this to your preferred region
}


module "jenkins" {
  source        = "./modules/jenkins"   # Path to the Jenkins module
  ami_id        = var.ami_id
  instance_type = var.instance_type
  # key_name      = var.key_name
}

module "build_node" {
  source        = "./modules/build-node"  # Path to the Build Node module
  ami_id        = var.ami_id
  instance_type = var.instance_type
}
#
module "sonar-nexus" {
  source = "./modules/sonar-nexus"  # Path to the Ansible module
  ami_id        = var.ami_id
  instance_type = var.instance_type
}

module "k8s" {
  source = "./modules/k8s"  # Path to the Ansible module
  ami_id        = var.ami_id
  instance_type = var.k8_instance_type
}