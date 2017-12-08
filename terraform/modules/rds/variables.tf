# RDS Module
# Davy Jones
# Cloudreach

variable "env" {
  description = "The Environment name of the VPC"
}

variable "prefix" {
  description = "Naming prefix to use"
}

variable "db_prefix" {
  description = "DB Name specific Naming prefix to use"
}

variable "owner" {
  description = "Identifying name of person who owns resource"
}

variable "vpc_id" {
  description = "The VPC to associate with the instance"
}

variable "instance_class" {
  description = "The instance size to use for the db"
}

variable "username" {
  description = "The username to authenticate with the db"
}

variable "password" {
  description = "The password to authenticate with the db"
}

variable "port" {
  description = "The port to connect to the db"
}

variable "security_group" {
  description = "The security group ID to associate with the instance"
}

variable "az" {
  description = "The availability zone to host the primary instance in"
}

variable "subnets" {
  description = "List of subnets to associate the RDS instance with"
}

variable "sns_topic" {
  description = "The ARN of the SNS Topic to use for DB event messages"
}

variable "multi_az" {
  description = "Do you want to enable multi_az on the RDS instance?"
  default     = false
}

variable "db_size" {
  description = "The GiB size of the instance"
}

variable "skip_final_snapshot" {
  description = "Do the final snapshot?"
}

variable "final_snapshot_name" {
  description = "Name of the final snapshot"
}
