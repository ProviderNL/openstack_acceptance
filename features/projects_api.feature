# coding: utf-8

Feature: OpenStack Project API
  As an OpenStack Admin
  I want to control projects with an API
  In order to provide projects on OpenStack

  Background:
    Given I have an OpenStack environment
    Given I have an admin account

  Scenario: List projects
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Then projects have at least one item

  Scenario: Create and delete project
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Given I generate a project name
    And that project name is not used
    When I create the new project
    Then that project can be retrieved
    And attribute enabled on that project should be true
    When I change the project attribute enabled to false
    And I reload the project
    Then I see on the project that the attribute enabled is false
    When I remove the project
    Then that project cannot be retrieved
