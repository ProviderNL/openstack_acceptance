# coding: utf-8

Feature: OpenStack KeyPair API
  As an OpenStack member
  I want to manage my keypairs with an API
  So I can use key based login on my VM

  Background:
    Given I have an OpenStack environment
    Given I have a member account
    Given I have a keypair locally

  Scenario: Manage key pairs
    Given I retrieve Compute service as a member
    And I only use the Compute service
    Given I generate a key_pair name
    And that key_pair name is not used
    When I create a new key_pair
    Then that key_pair can be retrieved
    When I remove the key_pair
    Then that key_pair cannot be retrieved
