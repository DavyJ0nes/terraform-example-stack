# ELB Module Variables
# Davy Jones
# Cloudreach

variable "env" {
  description = "The Environment name of the stack"
}

variable "prefix" {
  description = "Naming prefix to use"
}

variable "owner" {
  description = "Identifying name of person who owns resource"
}

variable "layer" {
  description = "The layer that the load balancer will serve"
}

variable "internal" {
  description = "Is the load balancer internal only?"
}

variable "ingress_security_groups" {
  description = "SGs to allow ingress access"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnets" {
  description = "List of subnets to be serviced from ELB"
}

variable "domain_name" {
  description = "The name of the domain to use"
}
