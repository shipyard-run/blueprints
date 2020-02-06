ingress "k8s-dashboard" {
    target = "cluster.k8s"
    service = "svc/kubernetes-dashboard"
    namespace = "kubernetes-dashboard"

    port {
        remote = 8443
        local = 8443
        host = 18443
    }
}

ingress "consul-http" {
  target = "cluster.k8s"
  service  = "svc/consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

ingress "web-api" {
    target = "cluster.k8s"
    service = "svc/web"

    port {
        local = 9090
        remote = 9090
        host = 9090
    }
}