# Auto Scaling Group Module

## Description

Terraform module to create an auto scaling group

## Usage

```shell
module "web_asg" {
  source                = "../../modules/asg"
  env                   = "${var.env}"
  prefix                = "${var.prefix}"
  owner                 = "${var.owner}"
  vpc_id                = "${module.vpc.vpc_id}"
  ami_search_term       = "${var.prefix}-${var.env}-web"
  azs                   = "${var.azs}"
  instance_type         = "${var.asg_instance_type}"
  instance_profile      = "${module.iam.instance_profile}"
  subnets               = "${module.vpc.private_subnet_ids}"
  max_size              = "${var.asg_max_size}"
  min_size              = "${var.asg_min_size}"
  desired_capacity      = "${var.asg_desired_capacity}"
  elb_name              = "${module.web_elb.elb_name}"
  in_security_group_ids = "${list("${module.web_elb.elb_sg}", "${module.bastion_host.bastion_sg}")}"
  sns_arn               = "${module.sns.sns_topic_arn}"
}
```