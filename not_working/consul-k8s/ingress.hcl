k8s_ingress "consul-http" {
  cluster = "k8s_cluster.k3s"

  network {
    name = "network.cloud"
  }

  service  = "consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
    open_in_browser = "/"
  }
  
  port {
    local  = 8300
    remote = 8300
    host   = 18300
  }
  
  port {
    local  = 8301
    remote = 8301
    host   = 18301
  }
  
  port {
    local  = 8302
    remote = 8302
    host   = 18302
  }
}

k8s_ingress "jaeger-http" {
  cluster = "k8s_cluster.k3s"

  network {
    name = "network.cloud"
  }

  service  = "jaeger-query"

  port {
    local  = 80
    remote = 80
    host   = 16686
    open_in_browser = "/"
  }
}

k8s_ingress "web-http" {
  cluster = "k8s_cluster.k3s"

  network {
    name = "network.cloud"
  }

  service  = "web-service"

  port {
    local  = 9090
    remote = 9090
    host   = 19090
    open_in_browser = "/ui"
  }
}
