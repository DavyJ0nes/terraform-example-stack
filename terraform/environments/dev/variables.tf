# Dev environment Variables
# Davy Jones
# Cloudreach

variable "env" {
  description = "Enviroment Name of the VPC"
}

variable "aws_region" {
  description = "AWS Region to use"
}

variable "prefix" {
  description = "Naming prefix to apply to Name Tag"
}

variable "db_prefix" {
  description = "Naming prefix to apply to the DB instance. RDS secifies only alpha numeric"
}

variable "owner" {
  description = "Identifying name of person who owns resource"
}

variable "cidr_range" {
  description = "User Assigned CIDR Range"
}

variable "azs" {
  description = "list of availablility zones"
}

variable "public_subnets" {
  description = "list of dev public subnets"
}

variable "private_subnets" {
  description = "list of dev private subnets"
}

variable "in_allowed_cidr_blocks" {
  description = "list of allowed ingress cidr_blocks"
}

variable "bastion_ami" {
  description = "The AMI ID to use with the bastion host"
}

variable "bastion_instance_type" {
  description = "The EC2 Instance Type to use with the bastion host"
}

variable "asg_instance_type" {
  description = "The instance type to use for the instances deployed within the ASG"
}

variable "asg_min_size" {
  description = "Minimum number of instances to have for the ASG"
}

variable "asg_max_size" {
  description = "Maximum number of instances to have for the ASG"
}

variable "asg_desired_capacity" {
  description = "The desired number of instances to have for the ASG"
}

variable "domain_name" {
  description = "The name of the domain to use"
}

variable "ssh_key_pair_name" {
  description = "Name of the EC2 Key pair to use. THIS MUST BE CREATED BEFORE HAND!"
}

variable "email" {
  description = "A users email address to use for subscribing to an SNS topic"
}

variable "db_username" {
  description = "Username to use with tbe RDS instance"
}

variable "db_password" {
  description = "Password to use with the RDS instance"
}

variable "db_port" {
  description = "Port Number to connect to RDS instance with"
  default     = 3306
}

variable "db_instance_class" {
  description = "The instance type to use with the RDS instance"
}

variable "db_size" {
  description = "The GiB size of the instance"
}
