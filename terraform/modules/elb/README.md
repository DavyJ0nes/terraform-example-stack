# ELB Module
> IGNORE THIS 
> This is here as a reminder that this can be done better in future.
> The use of the two repos is rally hacky but it works for now and need to ship.

## Description

This module creates an ELB that can be used to connect to instances that are running in the dev evironments private subnets. It defines the following resources:
- The ELB
- Security Groups
- Inbound Ports
- Any SSL certificates (currently not implemented)
- Subnet associations

## Usage
```
module "web_elb" {
  source                 = "../../modules/elb"
  env                    = "${var.env}"
  prefix                 = "${var.prefix}"
  owner                  = "${var.owner}"
  domain_name            = "${var.domain_name}"
  vpc_id                 = "${module.vpc.vpc_id}"
  subnets                = "${module.vpc.public_subnet_ids}"
  in_allowed_cidr_blocks = "${var.in_allowed_cidr_blocks}"
}
```
