# Creates Dev Stack
# Davy Jones 2017
# Cloudreach

terraform {
  backend "s3" {
    bucket = "testytesttest"
    key    = "terraform/qa"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

#---------- SET UP VPC ----------#

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

#---------- SET UP BASTION HOST ----------#

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

#---------- SET UP IAM ROLE AND PROFILE ----------#

module "iam" {
  source = "../../modules/iam"
  env    = "${var.env}"
  prefix = "${var.prefix}"
  owner  = "${var.owner}"
}

#---------- CREATE SNS TOPIC AND SUBSCRIPTION ----------# 

module "sns" {
  source = "../../modules/sns"
  env    = "${var.env}"
  prefix = "${var.prefix}"
  owner  = "${var.owner}"
  email  = "${var.email}"
}

#---------- SET UP WEB ELB ----------#

module "web_elb" {
  source       = "../../modules/elb/web_elb"
  env          = "${var.env}"
  prefix       = "${var.prefix}"
  owner        = "${var.owner}"
  layer        = "web"
  internal     = false
  domain_name  = "${var.domain_name}"
  vpc_id       = "${module.vpc.vpc_id}"
  subnets      = "${module.vpc.public_subnet_ids}"
  ingress_cidr = "0.0.0.0/0"
}

#---------- SET UP WEB AUTOSCALING GROUP ----------#

module "web_asg" {
  source                = "../../modules/asg"
  env                   = "${var.env}"
  prefix                = "${var.prefix}"
  owner                 = "${var.owner}"
  layer                 = "web"
  vpc_id                = "${module.vpc.vpc_id}"
  ami_search_term       = "${var.prefix}-base"
  azs                   = "${var.azs}"
  instance_type         = "${var.asg_instance_type}"
  instance_profile      = "${module.iam.instance_profile}"
  subnets               = "${module.vpc.private_subnet_ids}"
  max_size              = "${var.asg_max_size}"
  min_size              = "${var.asg_min_size}"
  desired_capacity      = "${var.asg_desired_capacity}"
  elb_name              = "${module.web_elb.elb_name}"
  in_security_group_ids = "${list("${module.web_elb.web_elb_sg}", "${module.bastion_host.bastion_sg}")}"
  sns_arn               = "${module.sns.sns_topic_arn}"
}

#---------- SET UP APP ELB ----------#

module "app_elb" {
  source                  = "../../modules/elb/app_elb"
  env                     = "${var.env}"
  prefix                  = "${var.prefix}"
  owner                   = "${var.owner}"
  layer                   = "app"
  internal                = true
  domain_name             = "${var.domain_name}"
  vpc_id                  = "${module.vpc.vpc_id}"
  subnets                 = "${module.vpc.private_subnet_ids}"
  ingress_security_groups = "${module.web_asg.asg_security_group_id}"
}

#---------- SET UP APP AUTOSCALING GROUP ----------#

module "app_asg" {
  source                = "../../modules/asg"
  env                   = "${var.env}"
  prefix                = "${var.prefix}"
  owner                 = "${var.owner}"
  layer                 = "app"
  vpc_id                = "${module.vpc.vpc_id}"
  ami_search_term       = "${var.prefix}-base"
  azs                   = "${var.azs}"
  instance_type         = "${var.asg_instance_type}"
  instance_profile      = "${module.iam.instance_profile}"
  subnets               = "${module.vpc.private_subnet_ids}"
  max_size              = "${var.asg_max_size}"
  min_size              = "${var.asg_min_size}"
  desired_capacity      = "${var.asg_desired_capacity}"
  elb_name              = "${module.app_elb.elb_name}"
  in_security_group_ids = "${list("${module.app_elb.app_elb_sg}", "${module.bastion_host.bastion_sg}")}"
  sns_arn               = "${module.sns.sns_topic_arn}"
}

#---------- CREATE RDS INSTANCE ----------# 

module "rds" {
  source              = "../../modules/rds"
  env                 = "${var.env}"
  prefix              = "${var.prefix}"
  db_prefix           = "${var.db_prefix}"
  owner               = "${var.owner}"
  db_size             = "${var.db_size}"
  vpc_id              = "${module.vpc.vpc_id}"
  multi_az            = false
  instance_class      = "${var.db_instance_class}"
  username            = "${var.db_username}"
  password            = "${var.db_password}"
  port                = "${var.db_port}"
  security_group      = "${module.app_asg.asg_security_group_id}"
  subnets             = "${module.vpc.private_subnet_ids}"
  sns_topic           = "${module.sns.sns_topic_arn}"
  az                  = "${element(split(",", var.azs), 0)}"
  skip_final_snapshot = true
  final_snapshot_name = "a"
}

#---------- CREATE AND ASSOCIATE RECORDS ----------# 

module "dns" {
  source      = "../../modules/route53"
  env         = "${var.env}"
  prefix      = "${var.prefix}"
  owner       = "${var.owner}"
  domain_name = "${var.domain_name}"
  elb_name    = "${module.web_elb.elb_dns_name}"
  elb_zone_id = "${module.web_elb.elb_zone_id}"
}

#---------- CREATE CLOUDWATCH LOGS & ALARMS ----------# 

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  env    = "${var.env}"
  prefix = "${var.prefix}"
  owner  = "${var.owner}"
}
