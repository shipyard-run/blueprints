container "tools" {
  image {
    name = "shipyardrun/tools:v0.3.0"
  }
  
  command = ["tail", "-f", "/dev/null"]

  network { 
    name = "network.onprem"
  }
}

docs "docs" {
  path  = "./docs"
  port  = 18080
  open_in_browser = true

  index_title = "DocsExample"
  index_pages = [ 
    "index",
  ]

  network {
    name = "network.onprem"
  }
}

network "onprem" {
  subnet = "10.7.0.0/16"
}