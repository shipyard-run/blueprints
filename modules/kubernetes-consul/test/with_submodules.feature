Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

@with_monitoring
Scenario: With Monitoring
    Given the following shipyard variables are set
      | key                               | value |
      | consul_monitoring_enabled         | true  |
      | consul_release_controller_enabled | false |
      | consul_tls_enabled                | false |
      | consul_acls_enabled               | false |
      | consul_ingress_gateway_enabled    | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200
    And a HTTP call to "http://localhost:8080" should result in status 200
    And a HTTP call to "http://localhost:9090" should result in status 200

@with_release_controller
Scenario: With Consul Release Controller
    Given the following shipyard variables are set
      | key                               | value       |
      | consul_smi_controller_enabled     | false       |
      | consul_release_controller_enabled | true        |
      | consul_tls_enabled                | true        |
      | consul_acls_enabled               | true        |
      | consul_ingress_gateway_enabled    | false       |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e

      echo "Checking Consul"
      curl --cacert ${HOME}/.shipyard/data/consul_kubernetes/tls.crt \
           --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/consul_kubernetes/bootstrap_acl.token)" \
           https://localhost:8501/v1/status/leader
      ```
    And I run the script
      ```
      #!/bin/bash -e

      echo "Checking Release Controller"
      curl -k
           https://localhost:19443/v1/health
      ```
