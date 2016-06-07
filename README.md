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

### Keystone
* Projects (list, create, delete, TODO: update, assignment)
* Roles (list, create, delete, TODO: update, assignment)
* Users (list, create, delete, TODO: update)

### Nova
* Servers (list, create, delete, TODO: update, and more)


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
