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

k8s_ingress "web" {
  cluster = "k8s_cluster.k3s"
  service  = "web"
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}

k8s_ingress "postgres" {
  cluster = "k8s_cluster.k3s"
  service  = "postgres"
  
  network {
    name = "network.cloud"
  }

  port {
    local  = 5432
    remote = 5432
    host   = 15432
  }
}