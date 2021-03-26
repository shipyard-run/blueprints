Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

Scenario: Standard Blueprint
    Given I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200

Scenario: Enabled TLS
    Given the following shipyard variables are set
      | key                 | value       |
      | consul_enable_tls   | true        |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the tls cert has been created
      if [ ! -f "${HOME}/.shipyard/data/helm/tls.crt" ]; then
        echo "TLS certificate does not exist."
        exit 1
      fi
      
      # Check the tls key has been created
      if [ ! -f "${HOME}/.shipyard/data/helm/tls.key" ]; then
        echo "TLS key does not exist."
        exit 1
      fi
      
      curl --cacert ${HOME}/.shipyard/data/helm/tls.crt \
           https://localhost:8500/v1/status/leader
      ```
    And I expect the exit code to be 0

Scenario: Enabled ACLs
    Given the following shipyard variables are set
      | key                 | value       |
      | consul_enable_acls  | true        |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the acl token has been created
      if [ ! -f "${HOME}/.shipyard/data/helm/bootstrap_acl.token" ]; then
        echo "ACL Root token does not exist."
        exit 1
      fi

      curl --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/helm/bootstrap_acl.token)" \
           http://localhost:8500/v1/status/leader --
      ```
    And I expect the exit code to be 0