# coding: utf-8

@cleanup
Feature: OpenStack Setup Test
  As an OpenStack tester
  I want to have a clean OpenStack test environment
  So I can test the services of my stack

  Background:
    Given I have an OpenStack environment
    And I have an admin account

  Scenario: List services
    Given I retrieve Identity service as an admin
    Then lingering projects, roles and users on Identity are cleaned
    Given I retrieve Compute service as an admin
    Then lingering flavors on Compute are cleaned
