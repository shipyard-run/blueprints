Feature: Vault Kubernetes
  In order to test the Vault and Kubernetes blueprint
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Kubernetes Cluster with Vault Helm Chart
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | k3s                       | k8s_cluster   |
    | web                       | ingress       |
    | postgres                  | ingress       |
    | vault-http                | ingress       |
    | docs                      | docs          |
    | tools                     | container     |
