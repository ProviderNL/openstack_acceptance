# coding: utf-8

Feature: OpenStack Project API
  As an OpenStack Admin
  I want to control projects with an API
  In order to provide projects on OpenStack

  Background:
    Given I have an OpenStack environment
    Given I have an admin account

  Scenario: List projects
    Given I retrieve 'Identity' service as an admin
    Then there is at least one project

  Scenario: Create and delete project
    Given I retrieve 'Identity' service as an admin
    Given I generate a unique project name
    And that project name is not used
    When I create the new project
    Then that project can be retrieved
    And that project should be enabled
    When I remove the project
    Then that project cannot be retrieved
