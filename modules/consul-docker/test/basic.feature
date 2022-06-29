Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

  @base
  Scenario: Standard Blueprint
    Given the following shipyard variables are set
      | key                               | value |
      | cd_consul_tls_enabled             | false |
      | cd_consul_acls_enabled            | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name            | type        |
      | local           | network     |
      | 1.consul.server | container   |
      | 2.consul.server | container   |
      | 3.consul.server | container   |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200
  
  @server_instances
  Scenario: Standard Blueprint
    Given the following shipyard variables are set
      | key                               | value |
      | cd_consul_server_instances        | 2     |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name            | type        |
      | local           | network     |
      | 1.consul.server | container   |
      | 2.consul.server | container   |

  @with_tls
  Scenario: Enabled TLS
    Given the following shipyard variables are set
      | key                               | value |
      | cd_consul_tls_enabled             | true  |
      | cd_consul_acls_enabled            | false |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name            | type        |
      | local           | network     |
      | 1.consul.server | container   |
      | 2.consul.server | container   |
      | 3.consul.server | container   |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the tls cert has been created
      if [ ! -f "${HOME}/.shipyard/data/consul/cd_consul_server.cert" ]; then
        echo "TLS certificate does not exist at path: ${HOME}/.shipyard/data/consul/cd_consul_server.cert"
        ls -las ${HOME}/.shipyard/data/consul
        exit 1
      fi
      
      if [ ! -f "${HOME}/.shipyard/data/consul/cd_consul_server.key" ]; then
        echo "TLS key does not exist at path: ${HOME}/.shipyard/data/consul/cd_consul_server.key"
        ls -las ${HOME}/.shipyard/data/consul
        exit 1
      fi
      
      curl --cacert ${HOME}/.shipyard/data/consul/cd_consul_ca.cert \
           https://localhost:8501/v1/status/leader
      ```
    And I expect the exit code to be 0

  @with_acls
  Scenario: Enabled ACLs
    Given the following shipyard variables are set
      | key                               | value |
      | cd_consul_tls_enabled             | false |
      | cd_consul_acls_enabled            | true  |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name            | type        |
      | local           | network     |
      | 1.consul.server | container   |
      | 2.consul.server | container   |
      | 3.consul.server | container   |
    And I run the script
      ```
      #!/bin/bash -e

      # Check the acl token has been created
      if [ ! -f "${HOME}/.shipyard/data/consul/bootstrap.token" ]; then
        echo "ACL Root token does not exist at path: ${HOME}/.shipyard/data/consul/bootstrap.token"
        ls -las ${HOME}/.shipyard/data/consul
        exit 1
      fi

      curl --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/consul/bootstrap.token)" \
           http://localhost:8500/v1/status/leader
      ```
    And I expect the exit code to be 0
  
  @with_acls_and_tls
  Scenario: Enabled ACLs and TLS
    Given the following shipyard variables are set
      | key                               | value |
      | cd_consul_tls_enabled             | true  |
      | cd_consul_acls_enabled            | true  |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name            | type        |
      | local           | network     |
      | 1.consul.server | container   |
      | 2.consul.server | container   |
      | 3.consul.server | container   |
    And I run the script
      ```
      #!/bin/bash -e
      curl --cacert ${HOME}/.shipyard/data/consul/cd_consul_ca.cert \
           --header "X-Consul-Token: $(cat ${HOME}/.shipyard/data/consul/bootstrap.token)" \
           https://localhost:8501/v1/status/leader
      ```
    And I expect the exit code to be 0
