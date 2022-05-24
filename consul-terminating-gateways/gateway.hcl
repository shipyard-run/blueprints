container "terminating-gateway" {
  depends_on = ["module.nomad_consul"]

  network {
    name       = "network.database"
    ip_address = "10.20.0.20"
  }

  network {
    name       = "network.dc1"
    ip_address = "10.15.0.240"
  }

  command = [
    "consul",
    "connect",
    "envoy",
    "-gateway=terminating",
    "-register",
    "-service",
    "mysql-gateway",
    "-address",
    "10.15.0.240:8443"
  ]

  image {
    name = "nicholasjackson/consul-envoy:v1.12.0-v1.22.0"
  }

  env {
    key   = "CONSUL_HTTP_ADDR"
    value = "consul.container.shipyard.run:8500"
  }

  env {
    key   = "CONSUL_GRPC_ADDR"
    value = "consul.container.shipyard.run:8502"
  }
}