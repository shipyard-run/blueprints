container_ingress "consul" {
  target = "container.consul"

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18600
  }
  
  port {
    local  = 8300
    remote = 8300
  }
  
  port {
    local  = 8301
    remote = 8301
  }
  
  port {
    local  = 8302
    remote = 8302
  }
}

nomad_ingress "nomad-http" {
  cluster  = "nomad_cluster.dev"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 4646
    remote = 4646
    host   = 14646
  }
}