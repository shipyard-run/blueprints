Feature: Consul Nomad Module
  In order to test the Consul Nomad blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Nomad cluster
  Given the following shipyard variables are set
    | key                   | value             |
    | cn_nomad_client_nodes | <nodes>           |
  And I have a running blueprint at path "./example"
  Then the following resources should be running
    | name                      | type          |
    | local                     | nomad_cluster |
    | consul                    | container     |
  And a HTTP call to "http://consul.container.shipyard.run:18500/v1/status/leader" should result in status 200
  And a HTTP call to "http://web.ingress.shipyard.run:19090/" should result in status 200
  Examples:
    | nodes |
    | 0     |
    | 3     |