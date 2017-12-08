# IAM Module

## Description
This module defines and creates the IAM Roles and Policies that are required by this application stack.

## Usage
```
module "iam" {
  source = "../../modules/iam"
  prefix = "${var.prefix}"
  owner  = "${var.owner}"
}
```
