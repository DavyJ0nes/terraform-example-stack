# Bastion Module

## Description

This module creates a bastion host that can be used to connect to instances that are running in the dev evironments private subnets. It defines the following resources:
- The Bastion Host
- Security Groups

## Usage
```
module "bastion_host" {
  source                 = "../../modules/bastion"
  env                    = "${var.env}"
  prefix                 = "${var.prefix}"
  owner                  = "${var.owner}"
  vpc_id                 = "${module.vpc.vpc_id}"
  public_subnet_id       = "${element(split(",", module.vpc.public_subnet_ids), 0)}"
  in_allowed_cidr_blocks = "${var.in_allowed_cidr_blocks}"
  bastion_ami            = "${var.bastion_ami}"
  bastion_instance_type  = "${var.bastion_instance_type}"
  key_name               = "${var.ssh_key_pair_name}"
}
```