nomad_ingress "nomad-onprem" {
  cluster  = "nomad_cluster.onprem"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 4646
    remote = 4646
    host   = 4646
  }
}

nomad_ingress "consul-onprem" {
  cluster  = "nomad_cluster.onprem"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
  }

  port {
    local  = 8300
    remote = 8300
  }

  port {
    local  = 8302
    remote = 8302
  }
}