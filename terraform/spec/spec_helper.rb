require 'awspec'
if File.exist?('spec/secrets.yml')
  creds = YAML.load_file('spec/secrets.yml')
  Aws.config.update({
                      region: creds['region'],
                      credentials: Aws::Credentials.new(
                        creds['aws_access_key_id'],
                        creds['aws_secret_access_key'])
                    })
end
