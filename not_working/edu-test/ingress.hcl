k8s_ingress "k8s-dashboard" {
    cluster = "k8s_cluster.k8s"
    service = "kubernetes-dashboard"
    namespace = "kubernetes-dashboard"

    network  {
      name = "network.local"
    }

    port {
        remote = 8443
        local = 8443
        host = 18443
    }
}

k8s_ingress "consul-http" {
  cluster = "k8s_cluster.k8s"
  service  = "consul-consul-server"
    
  network  {
    name = "network.local"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

k8s_ingress "web-api" {
    cluster = "k8s_cluster.k8s"
    service = "web"
    
    network  {
      name = "network.local"
    }

    port {
        local = 9090
        remote = 9090
        host = 9090
    }
}