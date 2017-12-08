# SNS Module

## Description
Terraform module to create a general SNS topic and subscribe an associated email address with the topic.
> Note that Terraform doesn't allow email as a protocol in their module so have had to work around this using a Cloudformation stack

## Usage
```
module "sns" {
  source = "../../modules/sns"
  env    = "${var.env}"
  prefix = "${var.prefix}"
  owner  = "${var.owner}"
  email  = "${var.email}"
}
```
