ingress "consul-k8s-http" {
  target = "cluster.k3s"
  service  = "svc/consul-consul-server"

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
  
  port {
    local  = 8300
    remote = 8300
  }
  
  port {
    local  = 8301
    remote = 8301
  }
  
  port {
    local  = 8302
    remote = 8302
  }
}

ingress "consul-nomad-http" {
  target = "container.consul"

  port {
    local  = 8500
    remote = 8500
    host   = 18600
  }
  
  port {
    local  = 8300
    remote = 8300
  }
  
  port {
    local  = 8301
    remote = 8301
  }
  
  port {
    local  = 8302
    remote = 8302
  }
}

ingress "nomad-http" {
  target  = "clusters.nomad"

  port {
    local  = 4646
    remote = 4646
    host   = 14646
  }
}

ingress "vault-http" {
  target = "cluster.k3s"
  service  = "svc/vault"

  port {
    local  = 8200
    remote = 8200
    host   = 18200
  }
}

ingress "public-api" {
  target = "cluster.k3s"
  service  = "svc/public-api-service"

  port {
    local  = 8080
    remote = 8080
    host   = 18080
  }
}

ingress "frontend" {
  target = "cluster.k3s"
  service  = "svc/frontend-service"

  port {
    local  = 80
    remote = 80
    host   = 10080
  }
}

ingress "prometheus-server" {
  target = "cluster.k3s"
  service  = "svc/prometheus-server"

  port {
    local  = 80
    remote = 80
    host   = 19100
  }
}

ingress "grafana" {
  target = "cluster.k3s"
  service  = "svc/grafana"

  port {
    local  = 80
    remote = 80
    host   = 13000
  }
}

ingress "jaeger" {
  target = "cluster.k3s"
  service  = "svc/jaeger"

  port {
    local  = 16686
    remote = 16686
    host   = 16686
  }
  
  port {
    local  = 9411
    remote = 9411
    host   = 19411
  }
}