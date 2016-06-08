# coding: utf-8

Feature: OpenStack Project API
  As an OpenStack Admin
  I want to control flavors with an API
  In order to provide choices to build VMs from on OpenStack

  Background:
    Given I have an OpenStack environment
    Given I have an admin account

  Scenario: List flavors
    Given I retrieve Compute service as an admin
    And I only use the Compute service
    Then flavors have at least one item

  Scenario: Create, change and delete flavor
    Given I retrieve Compute service as an admin
    And I only use the Compute service
    Given I generate a flavor name
    And that flavor name is not used
    When I create the new flavor with additional attributes:
    | ram       |   512 |
    | vcpus     |     1 |
    | disk      |     2 |
    | is_public |  true |
    Then that flavor can be retrieved
    When I remove the flavor
    Then that flavor cannot be retrieved
