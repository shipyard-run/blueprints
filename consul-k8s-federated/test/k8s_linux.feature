Feature: Test Kubernetes to Linux Connectivity
  In order to test Consul Mesh Gateways between Linux and Kubernetes
  environments.
  I should execute the following tests

  @k8s-linux
  Scenario: Kubernets and Linux Gateways
    Given the following shipyard variables are set
      | key                    | value                        |
      | consul_k8s_module      | ../modules/kubernetes-consul |
      | install_example_app    | true                         |
    And I have a running blueprint
    Then the following resources should be running
      | name                | type        |
      | local               | network     |
      | kubernetes          | k8s_cluster |
      | linux_server        | container   |
      | linux_gateway       | container   |
      | root_linux_app      | container   |
      | backend_linux_app   | container   |
    And a HTTP call to "https://localhost:8501/v1/status/leader" should result in status 200
    And a HTTP call to "http://localhost:18500/v1/status/leader" should result in status 200
    And a HTTP call to "http://localhost:19091" should result in status 200
    And a HTTP call to "http://localhost:19092" should result in status 200