k8s_ingress "consul-http" {
  cluster = "k8s_cluster.k3s"
  service  = "consul-consul-server"

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

k8s_ingress "k8s-dashboard" {
  cluster = "k8s_cluster.k3s"
  service = "kubernetes-dashboard"
  namespace = "kubernetes-dashboard"
  
  network {
    name = "network.cloud"
  }

  port {
    local = 8443
    remote = 8443
    host = 18443
  }
}

k8s_ingress "jaeger" {
  cluster = "k8s_cluster.k3s"
  service = "jaeger"
  
  network {
    name = "network.cloud"
  }

  port {
    local = 16686
    remote = 16686
    host = 16686
  }
}

k8s_ingress "gloo" {
  cluster = "k8s_cluster.k3s"
  service = "gateway-proxy-v2"
  namespace = "gloo-system"
  
  network {
    name = "network.cloud"
  }

  port {
    local = 80
    remote = 80
    host = 18080
  }
}