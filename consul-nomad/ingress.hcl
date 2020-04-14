container_ingress "consul" {
  target = "container.consul"

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18600
    open_in_browser = "/"
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
    open_in_browser = "/"
  }
}

nomad_ingress "jaeger-http" {
  cluster  = "nomad_cluster.dev"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 16686
    remote = 16686
    host   = 16686
    open_in_browser = "/"
  }
}

nomad_ingress "web" {
  cluster  = "nomad_cluster.dev"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
    open_in_browser = "/ui"
  }
}