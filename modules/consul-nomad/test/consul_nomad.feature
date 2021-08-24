Feature: Consul Nomad Module
  In order to test the Consul Nomad blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Node Nomad cluster
  Given the following shipyard variables are set
    | key                   | value             |
    | cn_nomad_client_nodes | 0                 |
  And I have a running blueprint at path "./example"
  Then the following resources should be running
    | name                      | type          |
    | server.local              | nomad_cluster |
    | web                       | nomad_ingress |
    | consul                    | container     |
  And a HTTP call to "http://consul.container.shipyard.run:18500/v1/status/leader" should result in status 200
  And a HTTP call to "http://web.ingress.shipyard.run:19090/" should result in status 200

Scenario: Multi-Node Nomad cluster
  Given the following shipyard variables are set
    | key                   | value             |
    | cn_nomad_client_nodes | 3                 |
  And I have a running blueprint at path "./example"
  Then the following resources should be running
    | name                      | type          |
    | server.local              | nomad_cluster |
    | 1.client.local            | nomad_cluster |
    | 2.client.local            | nomad_cluster |
    | 3.client.local            | nomad_cluster |
    | web                       | nomad_ingress |
    | consul                    | container     |
  And a HTTP call to "http://consul.container.shipyard.run:18500/v1/status/leader" should result in status 200
  And a HTTP call to "http://web.ingress.shipyard.run:19090/" should result in status 200