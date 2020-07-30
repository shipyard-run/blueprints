container "database" {
    network {
        name = "network.database"
        ip_address = "10.20.0.50"
    }

    image {
        name = "nicholasjackson/fake-service:v0.14.1"
    }
 
    env {
      key = "LISTEN_ADDR"
      value = ":3306"
    }
   
    env {
      key = "NAME"
      value = "database"
    }
}

container "terminating-gateway" {
  depends_on = ["container.consul"]

  network {
    name = "network.database"
    ip_address = "10.20.0.20"
  }
  network {
      name = "network.cloud"
      ip_address = "10.15.0.240"
  }

  volume {
    source      = "./consul_config/"
    destination = "/config/"
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
      name = "nicholasjackson/consul-envoy:v1.8.0-v1.12.4"
  }
  env {
    key = "CONSUL_HTTP_ADDR"
    value = "consul.container.shipyard.run:8500"
  }

  env {
    key = "CONSUL_GRPC_ADDR"
    value = "consul.container.shipyard.run:8502"
  }
}
