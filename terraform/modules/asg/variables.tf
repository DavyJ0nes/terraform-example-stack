# Auto Scaling Group Module
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

variable "layer" {
  description = "What layer should the ASG serve"
}

variable "ami_search_term" {
  description = "Name of the packerised AMI that you want to use"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "azs" {
  description = "list of availablility zones"
  default     = "eu-west-1a,eu-west-1b,eu-west-1c"
}

variable "instance_type" {
  description = "The instance type to use for the instances deployed within the ASG"
}

variable "instance_profile" {
  description = "The name of the instance profile to use for the EC2 instances"
}

variable "in_security_group_ids" {
  type        = "list"
  description = "security group IDs to be allowed access to instances"
}

variable "subnets" {
  description = "list of subnets to launch instances into. Should be private subnets"
}

variable "max_size" {
  description = "The min number of instances to have in the ASG"
}

variable "min_size" {
  description = "The min number of instances to have in the ASG"
}

variable "desired_capacity" {
  description = "The desired number of instances to have in the ASG"
}

variable "elb_name" {
  description = "The name of the Load Balancer to associate with the ASG"
}

variable "sns_arn" {
  description = "The ARN for the SNS Topic to send notifications to"
}
