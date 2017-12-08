# Bastion Host Module Variables
# Davy Jones
# Cloudreach

variable "env" {
  description = "The Environment name of the VPC"
}

variable "prefix" {
  description = "Naming prefix to use"
}

variable "owner" {
  description = "Identifying name of person who owns resource"
}

variable "vpc_id" {
  description = "The ID of the VPC to use"
}

variable "public_subnet_id" {
  description = "The public subnet ID to associate the instance with"
}

variable "in_allowed_cidr_blocks" {
  description = "list of allowed ingress cidr_blocks"
}

variable "bastion_ami" {
  description = "The AMI ID to use for the bastion host"
}

variable "bastion_instance_type" {
  description = "The EC2 Instance Type to use for the bastion host"
}

variable "key_name" {
  description = "The EC2 Key Pair name to use with the Bastion host"
}
