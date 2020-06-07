Kind = "ingress-gateway"
Name = "ingress-service"

TLS {
  Enabled = true
}

Listeners = [
  {
    Port = 443
    Protocol = "http"
    Services = [
      {
        Name = "api"
        Hosts = ["api.ingress.container.shipyard.run"]
      },
      {
        Name = "web"
        Hosts = ["web.ingress.container.shipyard.run"]
      }
    ]
  }
]