
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
