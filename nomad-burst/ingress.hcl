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
}

nomad_ingress "prometheus-onprem" {
  cluster  = "nomad_cluster.onprem"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}

nomad_ingress "grafana-onprem" {
  cluster  = "nomad_cluster.onprem"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 3000
    remote = 3000
    host   = 3000
  }
}

nomad_ingress "nginx-onprem" {
  cluster  = "nomad_cluster.onprem"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 80
    remote = 80
    host   = 80
  }
}