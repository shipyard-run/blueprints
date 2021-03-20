Feature: Consul Gateways
  In order to test the Consul Gateways
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | consul-dc1                | container     |
    | consul-dc2                | container     |
    | consul-gateway-dc1        | container     |
    | consul-gateway-dc2        | container     |
  And a HTTP call to "http://web-http-dc1.container.shipyard.run:19090/" should result in status 200