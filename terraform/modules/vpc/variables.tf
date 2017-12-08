# VPC Module Variables
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

variable "vpc_cidr" {
  description = "The CIDR range to use"
}

variable "public_subnets" {
  description = "The list of public subnets to create"
}

variable "private_subnets" {
  description = "The list of public subnets to create"
}

variable "azs" {
  description = "The list of AZs to deploy into"
}

variable "enable_dns_hostnames" {
  description = "Set to true if you want to use private DNS"
  default     = true
}

variable "enable_dns_support" {
  description = "Set to true if you want to use private DNS"
  default     = true
}
