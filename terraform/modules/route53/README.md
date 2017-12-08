# Route53 Module

## Description

This module manages Route 53 Hosted Zones and Record sets. 

## Usage
```
module "dns" {
  source      = "../../modules/route53"
  env         = "${var.env}"
  prefix      = "${var.prefix}"
  owner       = "${var.owner}"
  domain_name = "${var.domain_name}"
  elb_name    = "${module.web_elb.elb_dns_name}"
  elb_zone_id = "${module.web_elb.elb_zone_id}"
}
```