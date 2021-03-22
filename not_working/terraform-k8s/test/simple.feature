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
 Then a HTTP call to "http://consul.container.shipyard.run:8500/v1/status/leader" should result in status 200
 Then a HTTP call to "http://web.ingress.shipyard.run:19090" should result in status 200