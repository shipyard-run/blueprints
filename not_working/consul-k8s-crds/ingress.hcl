k8s_ingress "consul-http" {
  cluster = "k8s_cluster.dc1"
  depends_on = ["k8s_config.dc1"]


  network {
    name = "network.dc1"
  }

  service  = "consul-ui"

  port {
    local  = 80
    remote = 80
    host   = 80
  }
}

k8s_ingress "jaeger-http" {
  cluster = "k8s_cluster.dc1"
  depends_on = ["k8s_config.dc1"]


  network {
    name = "network.dc1"
  }

  service  = "jaeger-query"

  port {
    local  = 80
    remote = 80
    host   = 16686
  }
}

k8s_ingress "web-http" {
  cluster = "k8s_cluster.dc1"
  depends_on = ["k8s_config.dc1"]

  network {
    name = "network.dc1"
  }

  service  = "web-service"

  port {
    local  = 9090
    remote = 9090
    host   = 9090
  }
}