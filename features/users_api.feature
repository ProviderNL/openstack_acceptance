# coding: utf-8

@wip
Feature: OpenStack Users API
  As an OpenStack Admin
  I want to control users with an API
  In order to provide access on OpenStack

  Background:
    Given I have an OpenStack environment
    Given I have an admin account

  Scenario: List users
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Then users have at least one item

  Scenario: Create and delete user
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Given I generate a user name
    And that user name is not used
    When I create the new user
    Then that user can be retrieved
    And attribute enabled on that user should be true
    When I remove the user
    Then that user cannot be retrieved
