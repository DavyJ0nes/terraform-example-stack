# This test spec is used to ensure that the Ansible playbook for the Web Packer image is correct
require 'spec_helper'

# Check if required packages are installed
%w[nginx git nodejs npm].each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

# Check for Open Web Port
describe port(80) do
  it { should be_listening }
end

# Check config file exists for NGiNX
describe file('/etc/nginx/nginx.conf') do
  it { should exist }
end

# Check services are running and enabled
%w[nginx awslogs].each do |service|
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end
end

# Check that deploy user is set up
describe user('deploy') do
  it { should exist }
  it { should belong_to_group 'deploy' }
end

# Check if app code has been pulled
describe file('/srv/app/example-node-app/package.json') do
  it { should exist }
end

# Check if npm has been run
describe file('/srv/app/example-node-app/node_modules/express') do
  it { should exist }
end

# check if expected content ofindex.html returns through nginx
# describe command('curl -L https://localhost') do
#   its(:exit_status) { should eq 0 }
#   its(:stdout) { should match /Something Cool!!/ }
# end
