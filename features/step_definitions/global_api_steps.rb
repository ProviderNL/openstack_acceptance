# coding: utf-8

Given(/^I have an OpenStack environment\.$/) do
  expect($os_config.keys).to include('platform')
  @platform_config = $os_config['platform']
  expect(@platform_config.keys).to include('openstack_auth_url')
end

Given(/^I have an admin account$/) do
  @admin_config = $os_config['admin']
  @admin_connection_params = {
    provider: :openstack,
    openstack_auth_url: @platform_config['openstack_auth_url'] + '/auth/tokens',
    openstack_username: @admin_config['name'],
    openstack_api_key: @admin_config['api_key'],
    openstack_project_name: @admin_config['project'],
    openstack_domain_id: @admin_config['domain'],
    connection_options: { ssl_verify_peer: false },
  }

  # Connect to keystone
  @keystone = Fog::Identity.new @admin_connection_params

  # Check if we have an admin connection
  expect(@keystone.current_user).to eql('admin')
  expect(@keystone.current_tenant['name']).to eql('admin')
end

Given(/^I retrieve '(.*?)' service$/) do |service|
  # Save requested service as an instance variable
  self.instance_variable_set(
    "@#{service.downcase}",
    Fog.const_get(service).new(@admin_connection_params),
  )
end
