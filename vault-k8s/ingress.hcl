k8s_ingress "vault-http" {
  cluster = "k8s_cluster.k3s"
  service  = "vault"
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 8200
    remote = 8200
    host   = 18200
  }
}

k8s_ingress "k8s-dashboard" {
  cluster = "k8s_cluster.k3s"
  
  network {
    name = "network.cloud"
  }

  service = "kubernetes-dashboard"
  namespace = "kubernetes-dashboard"

  port {
    local = 8443
    remote = 8443
    host = 18443
  }
}