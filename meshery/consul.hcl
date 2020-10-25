helm "consul" {
  cluster = "k8s_cluster.k3s"

  chart = "github.com/hashicorp/consul-helm?ref=v0.24.1"

  health_check {
    timeout = "90s"
    pods = ["release=consul"]
  }

  values_string = {
    "server.storage" = "128Mi"
    "server.storageClass" = "local-path"
    "server.replicas" = "1"
    "server.bootstrapExpect" = "1"
    "client.enabled" = "true"
    "client.grpc" = "true"
    "ui.enabled" = "true"
    "connectInject.enabled" = "true"
    "connectInject.defaultProtocol" = "tcp"
    "connectInject.centralConfig.enabled" = "true"
    "connectInject.centralConfig.proxyDefaults" = <<EOF
      {
        "envoy_prometheus_bind_addr": "0.0.0.0:9102"
      }
    EOF
  }
}

ingress "consul" {
  target = "k8s_cluster.k3s"
  service = "svc/consul-consul-server"

  port {
    local = 8500
    remote = 8500
    host = 8500
  }
  
  network {
    name = "network.local"
  }
}