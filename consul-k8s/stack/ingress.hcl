ingress "consul-http" {
  target = "k8s_cluster.k3s"

  network {
    name = "network.cloud"
  }

  service  = "svc/consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}