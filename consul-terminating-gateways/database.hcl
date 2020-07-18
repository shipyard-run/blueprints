container "database" {
    network {
        name = "network.database"
        ip_address = "10.20.0.50"
    }

    image {
        name = "mariadb:latest"
    }

    env {
      key = "MYSQL_ROOT_PASSWORD"
      value = "SuperDuperSecureP@$$w0rd"
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
      name = "nicholasjackson/consul-envoy:v1.8.0-beta2-v0.14.1"
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

exec_remote "exec_container" {
  target = "container.consul"

  cmd = "curl"
  args = [
    "--request",
    "PUT",
    "--data",
    "@/config/mysql_svc.json",
    "localhost:8500/v1/catalog/register"
  ]
}