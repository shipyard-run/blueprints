container "consul_1" {
  image {
    name = "consul:1.8.0"
  }
  
  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network { 
    name = "network.onprem"
  }
}

container "consul_2" {
  image {
    name = "consul:1.8.0"
  }
  
  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network { 
    name = "network.onprem"
  }
}

container "consul_3" {
  image {
    name = "consul:1.8.0"
  }
  
  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }

  network { 
    name = "network.onprem"
  }
}