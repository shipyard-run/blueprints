Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

@with_monitoring
Scenario: With Monitoring
    Given the following shipyard variables are set
      | key                        | value       |
      | consul_enable_monitoring   | true        |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200
    And a HTTP call to "http://localhost:8080" should result in status 200
    And a HTTP call to "http://localhost:9090" should result in status 200
  
@with_smi_controller
Scenario: With SMI Controller
    Given the following shipyard variables are set
      | key                            | value       |
      | consul_enable_smi_controller   | true        |
    And I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8500/v1/status/leader" should result in status 200
