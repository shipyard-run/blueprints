nomad_ingress "web" {
  cluster  = "nomad_cluster.local"
  job = "web"
  group = "web"
  task = "web"
  
  network {
    name = "network.dc1"
  }

  port {
    local  = 9090
    remote = "http"
    host   = 19090
    open_in_browser = "/ui"
  }
}