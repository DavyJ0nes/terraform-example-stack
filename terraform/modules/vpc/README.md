# VPC Module

## Description
Terraform module to create a VPC that contains the following:
- Variable number of Public Subnets with attached Internet Gateway
- Variable number of Private Subnets with attached NAT Gateway with Elastic IP

## Usage
```
module "vpc" {
  source          = "../../modules/vpc"
  env             = "${var.env}"
  prefix          = "${var.prefix}"
  owner           = "${var.owner}"
  vpc_cidr        = "${var.cidr_range}"
  azs             = "${var.azs}"
  public_subnets  = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
}
```
