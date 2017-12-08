require 'spec_helper'

#---------- SETTING UP ----------#
environment = "qa"
prefix = "davyj0nes"
naming_prefix = "#{prefix}-#{environment}"
owner = "davy-jones"

#---------- TESTING VPC ----------#
describe vpc("#{naming_prefix}-vpc") do
  it { should exist }
  it { should be_available }
  its(:cidr_block) { should eq '10.240.0.0/16' }
  it { should have_route_table("#{naming_prefix}-public-0") }
  it { should have_route_table("#{naming_prefix}-public-1") }
  it { should have_route_table("#{naming_prefix}-public-2") }
  it { should have_route_table("#{naming_prefix}-private-0") }
  it { should have_route_table("#{naming_prefix}-private-1") }
  it { should have_route_table("#{naming_prefix}-private-2") }
  it { should have_tag('Owner').value("#{owner}") }
end

#---------- TESTING BASTION HOST ----------#
describe ec2("#{naming_prefix}-bastion") do
  it { should exist }
  it { should be_running }
  it { should belong_to_vpc("#{naming_prefix}-vpc") }
  it { should belong_to_subnet("#{naming_prefix}-public-0") }
  it { should have_tag('Owner').value("#{owner}") }
end

#---------- TESTING WEB ELB ----------#
describe elb("#{naming_prefix}-web-elb") do
  it { should exist }
  it { should belong_to_vpc("#{naming_prefix}-vpc") }
  it { should have_listener(protocol: 'HTTPS', port: 443, instance_protocol: 'HTTP', instance_port: 80) }
end

describe security_group("#{naming_prefix}-web-elb-sg") do
  it { should exist }
  its(:outbound) { should be_opened }
  its(:inbound) { should be_opened(443) }
end

#---------- TESTING WEB ASG ----------#
describe autoscaling_group("#{naming_prefix}-web-asg") do
  it { should exist }
  it { should have_elb("#{naming_prefix}-web-elb") }
  it { should have_tag('Owner').value("#{owner}") }
end

describe security_group("#{naming_prefix}-web-asg-sg") do
  it { should exist }
  its(:outbound) { should be_opened }
  its(:inbound) { should be_opened(80) }
end

#---------- TESTING APP ELB ----------#
describe elb("#{naming_prefix}-app-elb") do
  it { should exist }
  it { should belong_to_vpc("#{naming_prefix}-vpc") }
  it { should have_listener(protocol: 'HTTPS', port: 443, instance_protocol: 'HTTP', instance_port: 80) }
end

describe security_group("#{naming_prefix}-app-elb-sg") do
  it { should exist }
  its(:outbound) { should be_opened }
  its(:inbound) { should be_opened(443) }
end

#---------- TESTING WEB ASG ----------#
describe autoscaling_group("#{naming_prefix}-app-asg") do
  it { should exist }
  it { should have_elb("#{naming_prefix}-app-elb") }
  it { should have_tag('Owner').value("#{owner}") }
end

describe security_group("#{naming_prefix}-app-asg-sg") do
  it { should exist }
  its(:outbound) { should be_opened }
  its(:inbound) { should be_opened(80) }
end

#---------- TESTING ROUTE 53 ----------#
# Not sure on best way to test specific routes in here
describe route53_hosted_zone('example.com') do
  it { should exist }
end

#---------- TESTING SSL CERT EXISTS ----------#
describe acm('*.example.com') do
    it { should exist }
end

#---------- TESTING S3 ----------#
describe s3_bucket("#{naming_prefix}-web-elb-access-logs") do
  it { should exist }
  it { should have_tag('Owner').value("#{owner}") }
end

describe s3_bucket("testytesttest") do
  it { should exist }
  it { should have_object('terraform/qa') }
  it { should have_versioning_enabled }
  it { should have_tag('Owner').value("#{owner}") }
end

#---------- TESTING IAM ----------#
describe iam_role("#{naming_prefix}-iam-role") do
  it { should exist }
  it { should be_allowed_action('ec2:DescribeInstances') }
  it { should be_allowed_action('logs:CreateLogGroup') }
  it { should be_allowed_action('logs:CreateLogStream') }
  it { should be_allowed_action('logs:PutLogEvents') }
  it { should be_allowed_action('logs:DescribeLogStreams') }
end

#---------- TESTING RDS ----------#
describe rds("#{naming_prefix}") do
  it { should exist }
  it { should be_available }
  it { should belong_to_vpc("#{naming_prefix}-vpc") }
  it { should have_tag('Owner').value("#{owner}") }
end

describe security_group("#{naming_prefix}-rds-sg") do
  it { should exist }
  its(:inbound) { should be_opened(3306).protocol('tcp') }
  its(:outbound) { should be_opened }
end
