Feature: Test Blueprint
  In order to ensure that the Blueprint creates the required resources
  I should test the blueprint

Scenario: Standard Blueprint
    Given I have a running blueprint at path "./example"
    Then the following resources should be running
      | name                | type        |
      | dc1                 | network     |
      | dc1                 | k8s_cluster |
    And a HTTP call to "http://localhost:8200/v1/sys/health" should result in status 200