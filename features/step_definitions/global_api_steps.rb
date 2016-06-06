# coding: utf-8

Given(/^I have an OpenStack environment\.$/) do
  expect($os_config.keys).to include('platform')
  @platform_config = $os_config['platform']
  expect(@platform_config.keys).to include('openstack_auth_url')
end

def _access_account type
  # Get config
  config = $os_config[type.to_s]
  expect(config).not_to be_nil
  expect(@platform_config).not_to be_nil

  # Create connection params
  connection_params = {
    provider: :openstack,
    openstack_auth_url: @platform_config['openstack_auth_url'] + '/auth/tokens',
    openstack_username: config['name'],
    openstack_api_key: config['api_key'],
    openstack_project_name: config['project'],
    openstack_domain_id: config['domain'],
    connection_options: { ssl_verify_peer: false },
  }
  self.instance_variable_set("@#{type}_connection_params", connection_params)

  # Create keystone connection
  keystone = Fog::Identity.new(connection_params)
  self.instance_variable_set("@#{type}_keystone", keystone)

  # Check if we have a proper connection
  expect(keystone.current_user).to eql(config['name'])
  expect(keystone.current_tenant['name']).to eql(config['project'])
end

Given(/^I have an admin account$/) do
  _access_account :admin
end

Given(/^I have a member account$/) do
  _access_account :member
end

def _retrieve_service as, service
  # Save requested service as an instance variable
  self.instance_variable_set(
    "@#{service.downcase}",
    Fog.const_get(service).new(instance_variable_get("@#{as}_connection_params"))
  )
end

Given(/^I retrieve '(.*?)' service as an admin$/) do |service|
  _retrieve_service :admin, service
end

Given(/^I retrieve '(.*?)' service as a member$/) do |service|
  _retrieve_service :member, service
end
