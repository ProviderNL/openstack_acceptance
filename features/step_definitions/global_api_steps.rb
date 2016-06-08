# coding: utf-8

Given(/^I have an OpenStack environment$/) do
  %w{admin member}.each do |as|
    expect($os_config.keys).to include(as)
    expect($os_config[as]).to be_a Hash

    conf = $os_config[as]
    %w{auth_url name api_key project domain}.each do |key|
      expect(conf.keys).to include(key)
      expect(conf[key]).not_to be_nil
      expect(conf[key]).not_to eql('')
    end
  end
end

Given(/^I have an? (admin|member) account$/) do |type|
  # Get config
  config = $os_config[type]
  expect(config).not_to be_nil

  # Create connection params
  connection_params = {
    provider: :openstack,
    openstack_auth_url: config['auth_url'] + '/auth/tokens',
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

Given(/^I retrieve (\w+) service as an? (admin|member)$/) do |service,as|
  # Get connection params
  connection_params = instance_variable_get "@#{as}_connection_params"
  expect(connection_params).not_to be_nil

  # Save requested service as an instance variable
  self.instance_variable_set(
    "@#{service.downcase}",
    Fog.const_get(service).new(connection_params)
  )
end

Given(/I only use the (\w+) service/) do |service|
  @main_service = instance_variable_get("@#{service.downcase}")
end

Then(/(\w+) have at least one item/) do |model|
  expect(@main_service.send(model).all.count).to be >= 1
end

Given(/^I generate a (\w+) name$/) do |model|
  instance_variable_set(
    "@#{model}_name",
    "ccmbr-#{model}-#{SecureRandom.hex(4)}",
  )
end

def _pluralize model
  model.end_with?('s') ? model : "#{model}s"
end

def _singularize models
  models.end_with?('s') ? models[0..-2] : models
end

def _get_model_name model
  # Retrieve name
  name = instance_variable_get("@#{model}_name")
  expect(name).not_to be_nil
  name
end

def _get_model model, id, find_by = :name
  expect(@main_service).not_to be_nil
  @main_service.send(_pluralize(model)).all.select{|mod| mod.send(find_by) == id}.first
end

Given(/^that (\w+) name is not used$/) do |model|
  expect(_get_model(model, _get_model_name(model))).to be_nil
end

When(/^I create the new (\w+)$/) do |model|
  @main_service.send(_pluralize(model)).create(
    name: _get_model_name(model),
  )
end

When(/^I remove the (\w+)$/) do |model|
  model_obj = instance_variable_get("@#{model}")
  expect(model_obj).not_to be_nil
  model_obj.destroy
end

Then(/^that (\w+) can be retrieved$/) do |model|
  model_obj = _get_model(model, _get_model_name(model))
  instance_variable_set("@#{model}", model_obj)
  expect(model_obj).not_to be_nil
end

Then(/^that (\w+) cannot be retrieved$/) do |model|
  model_obj = _get_model(model, _get_model_name(model))
  instance_variable_set("@#{model}", model_obj)
  expect(model_obj).to be_nil
end

Then(/attribute (\w+) on that (\w+) should be (true|false)/) do |attribute,model_name,value|
  value = value.downcase == 'true'
  model = instance_variable_get("@#{model_name}")
  expect(model).not_to be_nil
  expect(model).to respond_to(attribute)
  expect(model.send(attribute)).to be value
end
