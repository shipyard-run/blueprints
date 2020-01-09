ingress "consul-http" {
  target = "cluster.k3s"
  service  = "svc/consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

ingress "k8s-dashboard" {
  target = "cluster.k3s"
  service = "svc/kubernetes-dashboard"
  namespace = "kubernetes-dashboard"

  port {
    local = 8443
    remote = 8443
    host = 18443
  }
}

ingress "jaeger" {
  target = "cluster.k3s"
  service = "svc/jaeger"

  port {
    local = 16686
    remote = 16686
    host = 16686
  }
}

ingress "gloo" {
  target = "cluster.k3s"
  service = "svc/gateway-proxy-v2"
  namespace = "gloo-system"

  port {
    local = 80
    remote = 80
    host = 18080
  }
}