k8s_ingress "consul-http" {
  cluster = "k8s_cluster.k3s"

  network {
    name = "network.cloud"
  }

  service  = "consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}