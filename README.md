# Terraform Example Stack

## Overview

This repository is used to demonstrate how you can use Packer and Terraform to create a basic 3 tier app. Here is a basic description for the problem that this repository intends to solve:

- Build a basic web app that should run within AWS using best practices. You should use Packer, Terraform and Jenkins to build the infrastructure in an automated fashion.

Please see [Caveats](## Caveats) section for relevant Caveats to using this repository

## Requirements

- Whole infrastructure as a code, revision controlled, deployed and tested using CI/CD
- Golden Images for instances built using packer
- Jenkins pipelines stored as a code
- Everything in private subnets with internet access via NAT gateways
- Instances set up with Autoscaling Groups being Elastic Load Balancers
- Instances built using config management tool, no changes made on the instances outside of the config management tool i.e. manually or through user data
- Deployment and rollback methodology
- No ssh access to QA and Prod

## Build Flow

- Images with required packages, OS updates and app code are to be built using Packer. These will become the deployment artifacts
- Once images are created, then Terraform will build the required environments (Dev, QA, Prod) depending on user requirements.

--------

## Packer

We are using AMIs that are built using Hashicorp Packer that uses Ansible to provision the image.

The Ansible playbook is located within `packer/playbooks`

### Testing

The playbook has related integration tests that can be found within `packer/playbooks/test/integration/default/serverspec`

These tests can be run using [Test Kitchen](http://kitchen.ci/) that utilises an Ubuntu 16.04 Docker image. See below for relevant commands and expected output:

```shell
# change to relvant directory from repo root
cd packer/playbooks

# Install relevant ruby gems to run Test Kitchen
bundle install # may require root

# set up test environment and provision using Ansible
kitchen converge

# Run Serverspec test suite
kitchen verify

## Expected output from kitchen verify:
-----> Starting Kitchen (v1.16.0)
           ...OUTPUT CUT...
       Finished in 0.21901 seconds (files took 0.27641 seconds to load)
       14 examples, 0 failures

       Finished verifying <default-ubuntu-1604> (0m5.81s).
-----> Kitchen is finished. (0m5.89s)

# Clean up test environment
kitchen destroy
```

### Caveats

- Only able to run on Ubuntu 16.04
- Expect machine to have Docker, Ansible and Ruby installed

--------

## Terraform

Terraform is an infrastructure provisioning framework from Hashicorp that integrates with many infrastructure providers (Azure/AWS/GCP etc).
Within this context we are using AWS as the infrastructure provider. Terraform is used to provision everything so that there are no manual steps (There is currently one manual step which is to create an S3 bucket to hold the remote state of terraform as explained [here](https://www.terraform.io/docs/backends/types/s3.html))

### Modules

The Terraform stack is set up with the following directory structure:

```shell
.
└── terraform
    ├── Gemfile
    ├── Gemfile.lock
    ├── Rakefile
    ├── environments
    │   ├── dev
    │   │   ├── README.md
    │   │   ├── dev.tf
    │   │   ├── dev.tfvars
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── prod
    │   │   ├── README.md
    │   │   ├── outputs.tf
    │   │   ├── prod.tf
    │   │   ├── prod.tfvars
    │   │   └── variables.tf
    │   └── qa
    │       ├── README.md
    │       ├── outputs.tf
    │       ├── qa.tf
    │       ├── qa.tfvars
    │       └── variables.tf
    ├── modules
    │   ├── asg
    │   │   ├── README.md
    │   │   ├── asg.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── bastion
    │   │   ├── README.md
    │   │   ├── bastion.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── cloudwatch
    │   │   ├── README.md
    │   │   ├── cloudwatch.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── elb
    │   │   ├── README.md
    │   │   ├── elb.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── iam
    │   │   ├── README.md
    │   │   ├── iam.tf
    │   │   ├── outputs.tf
    │   │   └── variables.tf
    │   ├── route53
    │   │   ├── README.md
    │   │   ├── outputs.tf
    │   │   ├── route53.tf
    │   │   └── variables.tf
    │   ├── sns
    │   │   ├── README.md
    │   │   ├── outputs.tf
    │   │   ├── sns.tf
    │   │   └── variables.tf
    │   └── vpc
    │       ├── README.md
    │       ├── outputs.tf
    │       ├── variables.tf
    │       └── vpc.tf
    └── spec
        ├── dev_spec.rb
        ├── prod_spec.rb
        ├── qa_spec.rb
        └── spec_helper.rb
```

We can easily see from this directory structure that we are defining three environments (Dev, QA and Prod).
We can also see that within the reusable modules that there is a good pattern:

- `variables.tf     == Inputs to the modules`
- `<module_name>.tf == Processing/work` 
- `outputs.tf       == Outputs from the module`

### Local Testing

> Concepts:
> [Terraform Validate](https://www.terraform.io/docs/commands/validate.html) 
> [Terraform Plan](https://www.terraform.io/docs/commands/plan.html)

You can do some local testing (validating and planning) locally using the `terraform validate|plan` commands to allow for a tighter feedback when working on the Dev environment but any deployments should be done using the Jenkins build server. This process is explained in the next section.

### Deployment

> DO NOT DEPLOY LOCALLY USING `terraform apply`
> ALL DEPLOYMENTS MUST BE DONE USING JENKINS

During this process an SNS topic is created and confirmation email is sent to the email that you specified in the `<env>.tfvars` file.

> NOTE THAT THIS FLOW NEEDS TO BE IMPROVED

### A Note about Naming

Naming convention for all created resources follows this schema:
`<username>-<env>-<resource_name>`
e.g:
`davyj0nes-dev-<resource_name>`

## TODO

- Improve testing of Packer image after it has been created
- Set up automatic builds on push
- Link up the Packer and Terraform build steps

## LICENSE

MIT 2017
