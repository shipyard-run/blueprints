container "consul" {
  image   {
    name = "consul:1.7.2"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network {
    name = "network.cloud"
  }
}