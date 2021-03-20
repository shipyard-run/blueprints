Feature: Consul Ingress
  In order to test the Shipyard docs
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Docs Coontaianer
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | docs                      | docs          |
    | tools                     | container     |
 Then a HTTP call to "http://docs.docs.shipyard.run:18080" should result in status 200