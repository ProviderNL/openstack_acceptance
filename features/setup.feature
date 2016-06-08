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
