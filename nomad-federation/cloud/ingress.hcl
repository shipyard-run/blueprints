nomad_ingress "nomad-cloud" {
  cluster  = "nomad_cluster.cloud"
  job = ""
  group = ""
  task = ""
  
  network {
    name = "network.wan"
  }

  port {
    local  = 4646
    remote = 4646
  }
}