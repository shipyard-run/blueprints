Feature: Test Kubernetes to Linux Connectivity
  In order to test Consul Mesh Gateways between Linux and Kubernetes
  environments.
  I should execute the following tests

  @k8s-linux
  Scenario: Kubernets and Linux Gateways
    Given the following shipyard variables are set
      | key                    | value                        |
      | consul_k8s_module      | ../modules/kubernetes-consul |
      | consul_docker_module   | ../modules/consul-docker     |
      | install_example_app    | true                         |
    And I have a running blueprint
    Then the following resources should be running
      | name                | type        |
      | local               | network     |
      | kubernetes          | k8s_cluster |
      | 1-consul-server     | container   |
      | gateway             | container   |
      | 1-web               | container   |
      | 1-currency          | container   |
    And a HTTP call to "https://localhost:8501/v1/status/leader" should result in status 200
    And a HTTP call to "https://localhost:18501/v1/status/leader" should result in status 200
    And a HTTP call to "http://localhost:29090" should result in status 200
