Feature: Vault Kubernetes
  In order to test the Vault and Kubernetes blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Kubernetes Cluster with Vault Helm Chart
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | dc1                       | k8s_cluster   |
    | docs                      | docs          |
    | tools                     | container     |
