
Given(/^I know the configuration for the member$/) do
  @member_config = $os_config['member']
  expect(@member_config).not_to be_nil
  %w{name api_key project ssh_key}.each do |key|
    expect(@member_config.keys).to include(key)
    expect(@member_config[key]).to be_a(String)
    expect(@member_config[key]).not_to eq('')
  end
end

Then(/^I want the project of the member to exist$/) do
  # We need identity and a member config
  expect(@identity).not_to be_nil
  expect(@member_config).not_to be_nil

  # Create the project if it does not exist
  @project = _get_model('project', @member_config['project'])
  unless @project
    @project = @identity.projects.create(
      name: @member_config['project'],
    )
  end

  # Check if the domain is correct
  expect(@project.domain_id).to eq(@member_config['domain'])
end

Then(/^I want the member to exist$/) do
  # We need identity and a member config
  expect(@identity).not_to be_nil
  expect(@member_config).not_to be_nil

  # Create the member if it does not exist
  @member = _get_model('user', @member_config['name'])
  unless @member
    @member = @identity.users.create(
      name: @member_config['name'],
      password: @member_config['api_key'],
    )
  end
end

Then(/^I want the role _member_ to exist$/) do
  # We need identity and a member config
  expect(@identity).not_to be_nil

  # Create the role if it does not exist
  @role = _get_model('role', '_member_')
  unless @role
    @identity.roles.create(
      name: '_member_',
    )
  end
end

Then(/^I want the member to be part of the project$/) do
  # We need identity, project, member and role
  expect(@identity).not_to be_nil
  expect(@project).not_to be_nil
  expect(@member).not_to be_nil
  expect(@role).not_to be_nil

  unless @project.check_user_role(@role.id, @member.id)
    @project.grant_role_to_user(@role.id, @member.id)
  end
end

Given(/^I have the keypair on disk$/) do
  # We need the member config
  expect(@member_config).not_to be_nil

  # Get key dir
  keys_path = File.expand_path('../../../.keys', __FILE__)
  Dir.mkdir(keys_path) unless File.exists?(keys_path)
  priv_path = File.join(keys_path, @member_config['ssh_key'])
  pub_path = File.join(keys_path, "#{@member_config['ssh_key']}.pub")

  # Check if key and pub exist
  if File.exists?(priv_path) && File.exists?(pub_path)
    @pub_key = File.read(pub_path)
  else
    rsa_key = OpenSSL::PKey::RSA.new 2048

    priv_file = File.new(priv_path, 'w')
    priv_file.write(rsa_key.to_pem)
    priv_file.close

    @pub_key = "#{rsa_key.ssh_type} #{[rsa_key.to_blob].pack('m0')}\n"

    pub_file = File.new(pub_path, 'w')
    pub_file.write(@pub_key)
    pub_file.close
  end

  expect(@pub_key).not_to be_nil
  expect(@pub_key).to start_with('ssh-rsa ')
end

Then(/^I want the keypair to exist on the platform$/) do
  expect(@member_config).not_to be_nil
  expect(@pub_key).not_to be_nil
  expect(@pub_key).to start_with('ssh-rsa ')

  unless @compute.key_pairs.get(@member_config['ssh_key'])
    @compute.key_pairs.create(
      name: @member_config['ssh_key'],
      public_key: @pub_key,
    )
  end
end
