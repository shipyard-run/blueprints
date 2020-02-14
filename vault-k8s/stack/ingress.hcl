ingress "vault-http" {
  target = "k8s_cluster.k3s"
  service  = "svc/vault"
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 8200
    remote = 8200
    host   = 18200
  }
}

ingress "k8s-dashboard" {
  target = "k8s_cluster.k3s"
  
  network {
    name = "network.cloud"
  }

  service = "svc/kubernetes-dashboard"
  namespace = "kubernetes-dashboard"

  port {
    local = 8443
    remote = 8443
    host = 18443
  }
}