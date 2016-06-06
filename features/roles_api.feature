# coding: utf-8

Feature: OpenStack Role API
  As an OpenStack Admin
  I want to control roles with an API
  In order to provide roles on OpenStack

  Background:
    Given I have an OpenStack environment
    Given I have an admin account

  Scenario: List roles
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Then roles have at least one item

  Scenario: Create and delete role
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Given I generate a role name
    And that role name is not used
    When I create the new role
    Then that role can be retrieved
    When I remove the role
    Then that role cannot be retrieved
