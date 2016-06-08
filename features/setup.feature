# coding: utf-8

@setup
Feature: OpenStack Setup Test
  As an OpenStack tester
  I want to be able to connect to OpenStack using an API
  So I can test the services of my stack

  Background:
    Given I have an OpenStack environment
    And I have an admin account

  Scenario: List services as an admin
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    Then services have at least one item

  Scenario: Member exists
    Given I retrieve Identity service as an admin
    And I only use the Identity service
    And I know the configuration for the member
    Then I want the project of the member to exist
    And I want the member to exist
    And I want the role _member_ to exist
    And I want the member to be part of the project

  Scenario: Member has a keypair
    Given I have a member account
    And I retrieve Identity service as a member
    And I retrieve Compute service as a member
    And I know the configuration for the member
    And I have the keypair on disk
    Then I want the keypair to exist on the platform
