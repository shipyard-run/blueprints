Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

  @base
  Scenario: Standard Blueprint
    Given the following shipyard variables are set
      | key                           | value |
      | consul_tls_enabled            | false |
      | consul_acls_enabled           | false |
      | consul_monitoring_enabled     | false |
      | consul_smi_controller_enabled | false |
      | consul_flagger_enabled        | false |
      | consul_ingress_gateway_enabled | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200

  @with_tls
  Scenario: Enabled TLS
    Given the following shipyard variables are set
      | key                 | value        |
      | consul_tls_enabled   | true        |
      | consul_acls_enabled  | false       |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the tls cert has been created
      if [ ! -f "${HOME}/.shipyard/data/consul_kubernetes/tls.crt" ]; then
        echo "TLS certificate does not exist at path: ${HOME}/.shipyard/data/consul_kubernetes/tls.crt"
        ls -las ${HOME}/.shipyard/data/consul_kubernetes
        exit 1
      fi
      
      # Check the tls key has been created
      if [ ! -f "${HOME}/.shipyard/data/consul_kubernetes/tls.key" ]; then
        echo "TLS key does not exist at path: ${HOME}/.shipyard/data/consul_kubernetes/tls.key"
        ls -las ${HOME}/.shipyard/data/consul_kubernetes
        exit 1
      fi
      
      curl --cacert ${HOME}/.shipyard/data/consul_kubernetes/tls.crt \
           https://localhost:8501/v1/status/leader
      ```
    And I expect the exit code to be 0

  @with_acls
  Scenario: Enabled ACLs
    Given the following shipyard variables are set
      | key                            | value |
      | consul_tls_enabled             | false |
      | consul_acls_enabled            | true  |
      | consul_monitoring_enabled      | false |
      | consul_smi_controller_enabled  | false |
      | consul_ingress_gateway_enabled | false |
      | consul_flagger_enabled         | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the acl token has been created
      if [ ! -f "${HOME}/.shipyard/data/consul_kubernetes/bootstrap_acl.token" ]; then
        echo "ACL Root token does not exist at path: ${HOME}/.shipyard/data/consul_kubernetes/bootstrap_acl.token"
        ls -las ${HOME}/.shipyard/data/consul_kubernetes
        exit 1
      fi

      curl --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/consul_kubernetes/bootstrap_acl.token)" \
           http://localhost:8500/v1/status/leader
      ```
    And I expect the exit code to be 0
  
  @with_acls_and_tls
  Scenario: Enabled ACLs and TLS
    Given the following shipyard variables are set
      | key                            | value |
      | consul_acls_enabled            | true  |
      | consul_tls_enabled             | true  |
      | consul_monitoring_enabled      | false |
      | consul_smi_controller_enabled  | false |
      | consul_ingress_gateway_enabled | false |
      | consul_flagger_enabled         | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e
      curl --cacert ${HOME}/.shipyard/data/consul_kubernetes/tls.crt \
           --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/consul_kubernetes/bootstrap_acl.token)" \
           https://localhost:8501/v1/status/leader
      ```
    And I expect the exit code to be 0

  @with_ingress_gateway
  Scenario: With Ingress Gateway
    Given the following shipyard variables are set
      | key                            | value |
      | consul_ingress_gateway_enabled | true  |
      | consul_tls_enabled             | false |
      | consul_acls_enabled            | false |
      | consul_monitoring_enabled      | false |
      | consul_smi_controller_enabled  | false |
      | consul_flagger_enabled         | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200
    And a HTTP call to "http://api.ingress.shipyard.run:18080" should result in status 200
