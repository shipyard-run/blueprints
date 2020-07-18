container "consul" {
  image   {
    name = "consul:1.8.0-beta2"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network {
    name = "network.cloud"
  }

  port {
    local = 8500
    remote = 8500
    host = 8500
  }

  health_check {
    http = "http://consul.container.shipyard.run:8500/v1/status/leader"
    timeout = "10s"
  }
}