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


## Acceptance tests


### Compute API acceptance

`cucumber features/compute_api.feature`

#### Scnario and result

```
# coding: utf-8
Feature: OpenStack Compute API
  In order to provide services on OpenStack
  As a OpnStack user
  I want to control an infrastructure with remote api

  Background: We have own OpenStack environment.            # features/compute_api.feature:8
    Given I have an account which roled member of OpenStack # features/step_definitions/compute_api_steps.rb:4
    And My current tenant is available                      # features/step_definitions/compute_api_steps.rb:29

  Scenario: Verify available Nework                         # features/compute_api.feature:12
    Given I retrieve "Network" from API                     # features/step_definitions/compute_api_steps.rb:17
    Then There is at least one ACTIVE router                # features/step_definitions/compute_api_steps.rb:35
    And It has network "ext_net"                            # features/step_definitions/compute_api_steps.rb:41
    And It has network "int_net"                            # features/step_definitions/compute_api_steps.rb:41

  Scenario: Verify available Images                         # features/compute_api.feature:18
    Given I retrieve "Image" from API                       # features/step_definitions/compute_api_steps.rb:17
    Then There are at least one image                       # features/step_definitions/compute_api_steps.rb:46

  Scenario: Verify computer dependencies                    # features/compute_api.feature:22
    Given I retrieve "Compute" from API                     # features/step_definitions/compute_api_steps.rb:17
    Then There are at least one flavor                      # features/step_definitions/compute_api_steps.rb:51
    Then There are at least one keypair                     # features/step_definitions/compute_api_steps.rb:56

  Scenario: Create and destroy Computer                               # features/compute_api.feature:27
    Given I retrieve "Network" from API                               # features/step_definitions/compute_api_steps.rb:17
    Given I retrieve "Image" from API                                 # features/step_definitions/compute_api_steps.rb:17
    Given I retrieve "Compute" from API                               # features/step_definitions/compute_api_steps.rb:17
    When A requirement which must be satisfied before create computer # features/step_definitions/compute_api_steps.rb:61
    And I try to create computer with private nic                     # features/step_definitions/compute_api_steps.rb:71
    Then new computer should be ACTIVE                                # features/step_definitions/compute_api_steps.rb:86
    When I create floating_ip and associate to new computer           # features/step_definitions/compute_api_steps.rb:99
    Then computer has valid attributes                                # features/step_definitions/compute_api_steps.rb:112
    When I try to destroy new computer                                # features/step_definitions/compute_api_steps.rb:95
    And I release floating_ip                                         # features/step_definitions/compute_api_steps.rb:107

4 scenarios (4 passed)
27 steps (27 passed)
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
