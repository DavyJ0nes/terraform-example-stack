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

variable "domain_name" {
  description = "The name of the domain to use"
}

variable "elb_name" {
  description = "The name of the elastic load balancer to associate with Alias record"
}

variable "elb_zone_id" {
  description = "The zone ID of the elastic load balancer to associate with Alias record"
}
