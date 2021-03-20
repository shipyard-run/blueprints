Feature: Consul Ingress
  In order to test the Consul Ingress
  I should apply a blueprint which defines the setup
  and test the resources are created correctly

Scenario: Single Container from Local Blueprint
  Given I have a running blueprint
  Then the following resources should be running
    | name                      | type          |
    | consul                    | container     |
    | ingress                   | container     |
    | api                       | container     |
    | web                       | container     |
 Then a HTTP call to "http://consul.container.shipyard.run:8500/v1/status/leader" should result in status 200
 When I run the script
  ```
  #!/bin/bash -e

  # Load the central config
  curl -XPUT http://consul.container.shipyard.run:8500/v1/config -d '
  {
    "Kind": "ingress-gateway",
    "Name":"ingress-service",
    "TLS": {
      "Enabled": true
    },
    "Listeners": [
      {
        "Port": 443,
        "Protocol": "http",
        "Services": [
          {
            "Name": "api",
            "Hosts": ["api.ingress.container.shipyard.run"]
          },
          {
            "Name": "web",
            "Hosts": ["web.ingress.container.shipyard.run"]
          }
        ]
      }
    ]
  }
  '

  # Test the services
  curl -k https://web.ingress.container.shipyard.run
  curl -k https://api.ingress.container.shipyard.run
  ```