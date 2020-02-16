ingress "consul-http" {
  target = "k8s_cluster.k3s"
  service  = "svc/consul-consul-server"

  network {
    name = "network.cloud"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

ingress "k8s-dashboard" {
  target = "k8s_cluster.k3s"
  service = "svc/kubernetes-dashboard"
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

ingress "jaeger" {
  target = "k8s_cluster.k3s"
  service = "svc/jaeger"
  
  network {
    name = "network.cloud"
  }

  port {
    local = 16686
    remote = 16686
    host = 16686
  }
}

ingress "gloo" {
  target = "k8s_cluster.k3s"
  service = "svc/gateway-proxy-v2"
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