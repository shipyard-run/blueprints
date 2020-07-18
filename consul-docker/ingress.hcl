container_ingress "consul-http" {
  target  = "container.consul_1"

  network {
    name = "network.onprem"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
    open_in_browser = "/ui"
  }
}

container_ingress "app" {
  target  = "container.api_1"

  network {
    name = "network.onprem"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 19090
    open_in_browser = "/ui"
  }
}