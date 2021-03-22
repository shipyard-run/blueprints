nomad_ingress "api" {
  cluster  = var.cn_nomad_cluster_name

  job = "api"
  group = "api"
  task = "admin"

  network {
    name = "network.dc1"
  }

  port {
    local  = 8080
    remote = "http"
    host   = 8080
    open_in_browser = "/"
  }
}