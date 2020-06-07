Kind = "ingress-gateway"
Name = "ingress-service"

TLS {
  Enabled = true
}

Listeners = [
  {
    Port = 8080
    Protocol = "http"
    Services = [
      {
        Name = "api"
        Hosts = ["api.ingress.container.shipyard.run", "api.ingress.container.shipyard.run:8080"]
      },
      {
        Name = "web"
        Hosts = ["web.ingress.container.shipyard.run", "web.ingress.container.shipyard.run:8080"]
      }
    ]
  }
]