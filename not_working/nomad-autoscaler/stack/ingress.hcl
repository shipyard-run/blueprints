nomad_ingress "web" {
  cluster  = "nomad_cluster.nomad"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 80
    remote = 80
    host   = 80
  }
}

nomad_ingress "grafana" {
  cluster  = "nomad_cluster.nomad"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 3000
    remote = 3000
    host   = 3000
  }
}  

nomad_ingress "prometheus" {
  cluster  = "nomad_cluster.nomad"
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
  }
}

nomad_ingress "haproxy" {
  cluster  = "nomad_cluster.nomad"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 1936
    remote = 1936
    host   = 1936
  }
} 

nomad_ingress "consul-nomad-http" {
  cluster  = "nomad_cluster.nomad"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 8500
  }
} 

nomad_ingress "nomad-http" {
  cluster  = "nomad_cluster.nomad"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 4646
    remote = 4646
    host   = 4646
  }
}   