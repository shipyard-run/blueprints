network "dc1" {
  subnet = "10.5.0.0/16"
}

k8s_cluster "dc1" {
  driver  = "k3s"
  version = "v1.0.1"

  nodes = 1

  network {
    name = "network.dc1"
  }

  image {
    name = "consul:1.8.2"
  }
}

helm "consul" {
  cluster = "k8s_cluster.dc1"

  chart = "github.com/hashicorp/consul-helm?ref=d3dd318f0d194f0147d73b35bf86a2ec028b277c"
  values = "./helm/consul-values.yaml"

  health_check {
    timeout = "60s"
    pods = ["app=consul"]
  }
}

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
    open_in_browser = "/"
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
    open_in_browser = "/"
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
    open_in_browser = "/ui"
  }
}

k8s_config "dc1" {
  cluster = "k8s_cluster.dc1"
  depends_on = ["helm.consul"]

  paths = [
    "./k8s_config/web.yaml",
    "./k8s_config/app.yaml",
    "./k8s_config/jaeger.yaml"
  ]

  wait_until_ready = true
}