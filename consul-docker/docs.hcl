docs "docs" {
  path  = "./_docs"
  port  = 18080
  
  network {
    name = "network.onprem"
  }
}

container "tools" {
  image   {
    name = "shipyardrun/tools:latest"
  }
  
  network {
    name = "network.onprem"
  }

  command = ["tail", "-f", "/dev/null"]

 # Working files
  volume {
    source      = "./files"
    destination = "/files"
  }

  env {
    key = "CONSUL_HTTP_ADDR"
    value = "http://consul.container.shipyard:8500"
  }
}