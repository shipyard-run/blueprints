Feature: Vault Docker
  In order to test the Vault in Docker blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | vault                     | container     |
  And a HTTP call to "http://localhost:8200/" should result in status 200
