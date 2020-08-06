Feature: Consul Docker
  In order to test the Consul in Docker blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | consul-1                  | container     |
    | consul-2                  | container     |
    | consul-3                  | container     |