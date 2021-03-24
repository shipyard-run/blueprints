Feature: Meshery
  In order to test the Meshery blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Meshery running on Kubernetes
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | dc1                       | k8s_cluster   |
  And a HTTP call to "http://consul.ingress.shipyard.run:8500/" should result in status 200
  And a HTTP call to "http://meshery.ingress.shipyard.run:9081/" should result in status 200
