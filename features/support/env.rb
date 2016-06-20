require 'rspec/matchers'
require 'rspec/expectations'
require 'fog'
require 'fog/openstack'
require 'net/ssh'
require 'yaml'

include RSpec::Matchers
include RSpec::Expectations

config_file = File.expand_path('../../../.os_accept.yml',__FILE__)
unless File.exists?(config_file)
  puts 'ConfigFile Not Found. Try `./bin/os_accept init` first.'
  exit
end
$os_config = YAML.load_file(config_file)

# Keypair path
$keys_path = File.expand_path('../../../.keys', __FILE__)
Dir.mkdir($keys_path) unless File.exists?($keys_path)
