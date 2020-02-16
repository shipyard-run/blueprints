container "consul" {
  image   {
    name = "consul:1.6.2"
  }

  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network {
    name = "network.cloud"
    # If manually setting IP addresses work from the back of 
    # the block to avoid conflicts.
    # Docker always assigns from the begining of the block
    # ip_address = "10.15.0.200"
  }
}