env = "prod"

aws_region = "eu-west-1"

prefix = "davyj0nes"

db_prefix = "Davyj0nes"

owner = "davy-jones"

cidr_range = "10.250.0.0/16"

azs = "eu-west-1a,eu-west-1b,eu-west-1c"

public_subnets = "10.250.11.0/24,10.250.12.0/24,10.250.13.0/24"

private_subnets = "10.250.14.0/24,10.250.15.0/24,10.250.16.0/24"

in_allowed_cidr_blocks = "185.73.154.30/32"

bastion_ami = "ami-d7b9a2b1"

bastion_instance_type = "t2.micro"

web_instance_type = "t2.micro"

ssh_key_pair_name = "davyjones-ao-ireland"

asg_instance_type = "t2.micro"

asg_min_size = 2

asg_max_size = 6

asg_desired_capacity = 3

domain_name = "example.com"

email = "test@example.com"

db_instance_class = "db.t2.micro"

db_username = "db_user"

db_password = "abcdefghi123456789"

db_size = 5