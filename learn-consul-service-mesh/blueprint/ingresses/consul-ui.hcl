ingress "consul-ui" {
  target = "k8s_cluster.k8s"
  service  = "svc/hashicorp-consul-ui"
    
  network  {
    name = "network.local"
  }

  port {
    local  = 80
    remote = 80
    host   = 18500
  }
}
