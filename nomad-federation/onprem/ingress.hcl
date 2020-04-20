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