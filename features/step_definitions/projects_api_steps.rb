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

Then(/^there is at least one project$/) do
  @avail_projects = @identity.projects.all
  expect(@avail_projects.count).to be >= 1
end

Given(/^I generate a unique project name$/) do
  @project_name = "cucumber-#{SecureRandom.hex(12)}"
end

Given(/^that project name is not used$/) do
  expect(get_project).to be_nil
end

When(/^I create the new project$/) do
  @identity.projects.create(
    name: @project_name,
  )
end

Then(/^that project can be retrieved$/) do
  @project = get_project
  expect(@project).not_to be_nil
end

Then(/^that project should be enabled$/) do
  expect(@project.enabled).to be true
end

When(/^I remove the project$/) do
  @project.destroy
end

Then(/^that project cannot be retrieved$/) do
  expect(get_project).to be_nil
end

# Helpers
def get_project
  expect(@identity).not_to be_nil
  @identity.projects.all.select{|pr| pr.name == @project_name}.first
end
