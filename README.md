# OpenStack acceptance test with cucumber

When you have an OpenStack (private) cloud, you can use this test suite to verify if components are
working as they should. The first iteration will only test the basics of the stack.


## Requirements

### Local requirements
* Ruby version: >= 1.9.3
* System dependencies: rubygems, bundler

### OpenStack Requirements

* Your Keystone should have a role `_member_`
* The member from the config should have role `_member_` on the project it's assigned to
* This member should have a public keypair
* At least one image should be imported to test nova

## Getting started

1. Clone the repository: `git clone git@github.com:ProviderNL/openstack_acceptance.git`
2. (_optional_) if using rbenv/rvm: set the ruby version you want to use and verify the correct version is used
3. Make sure the bundler gem is installed: `gem install bundler`
4. Run bundler to install all required gems: `bundler install`
5. Copy `os_accept.sample.yml` to `.os_accept.yml` and enter your credentials
6. Run `bundle exec cucumber --tags @setup` to verify your credentials and to make sure the member is setup correctly

To run the full suite, use:

    bundle exec cucumber

To use guard for development of additional tests:

    bundle exec guard

To cleanup after failed runs, you can run:

    bundle exec cucumber --tags @cleanup

## Acceptance tests

### Keystone
* Projects (list, create, delete, TODO: update, assignment)
* Roles (list, create, delete, TODO: update, assignment)
* Users (list, create, delete, TODO: update)

### Nova
* Servers (list, create, delete, TODO: update, and more)

### Example run
```
# coding: utf-8
Feature: OpenStack Users API
  As an OpenStack Admin
  I want to control users with an API
  In order to provide access on OpenStack

  Background:                             # features/users_api.feature:9
    Given I have an OpenStack environment # features/step_definitions/global_api_steps.rb:3
    Given I have an admin account         # features/step_definitions/global_api_steps.rb:9

  Scenario: List users                            # features/users_api.feature:13
    Given I retrieve Identity service as an admin # features/step_definitions/global_api_steps.rb:36
    And I only use the Identity service           # features/step_definitions/global_api_steps.rb:44
    Then users have at least one item             # features/step_definitions/global_api_steps.rb:48

  Scenario: Create and delete user                # features/users_api.feature:18
    Given I retrieve Identity service as an admin # features/step_definitions/global_api_steps.rb:36
    And I only use the Identity service           # features/step_definitions/global_api_steps.rb:44
    Given I generate a user name                  # features/step_definitions/global_api_steps.rb:52
    And that user name is not used                # features/step_definitions/global_api_steps.rb:80
    When I create the new user                    # features/step_definitions/global_api_steps.rb:84
    Then that user can be retrieved               # features/step_definitions/global_api_steps.rb:96
    And that user should be enabled               # features/step_definitions/global_api_steps.rb:108
    When I remove the user                        # features/step_definitions/global_api_steps.rb:90
    Then that user cannot be retrieved            # features/step_definitions/global_api_steps.rb:102

2 scenarios (2 passed)
16 steps (16 passed)
0m1.414s
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
- sawanoboryu@higanworks.com (HiganWorks LLC)
- Ferdi van der Werf <ferdi@provider.nl>

Licensed under the MIT License;
