container "consul" {
  image {
    name = "consul:1.8.0"
  }
  
  command = ["consul", "agent", "-config-file=/config/consul.hcl"]

  volume {
    source      = "./consul_config"
    destination = "/config"
  }
  
  volume {
    source      = "./files"
    destination = "/files"
  }

  network { 
    name = "network.onprem"
  }
  
  port {
    local  = 8300
    remote = 8300
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
    open_in_browser = "/ui"
  }
}