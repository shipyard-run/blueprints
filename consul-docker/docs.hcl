docs "docs" {
  path  = "./docs"
  port  = 18080
  
  network {
    name = "network.onprem"
  }

  # Title for the sidebar
  index_title = "Consul"

  # id of pages to add to the sidebar
  index_pages = ["index"]
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
    value = "http://consul-1.container.shipyard.run:8500"
  }
}