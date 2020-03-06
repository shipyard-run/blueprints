ingress "consul-http" {
  target  = "container.consul"

  network {
    name = "network.onprem"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

ingress "app" {
  target  = "container.api_1"

  network {
    name = "network.onprem"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 19090
  }
}