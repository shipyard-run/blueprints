Feature: Consul Ingress
  In order to test the Consul Ingress
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | consul                    | container     |
    | ingress                   | container     |
    | api                       | container     |
    | web                       | container     |