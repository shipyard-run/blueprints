helm "prometheus_stack" {
  cluster = "k8s_cluster.k3s"
  chart_name = "prometheus-stack"

  chart = "github.com/prometheus-community/helm-charts/charts//kube-prometheus-stack"

  values_string = {
    "alertmanager.enabled" = "false"
    "grafana.enabled" = "false"
  }
  
  health_check {
    timeout = "90s"
    pods = ["release=prometheus-stack"]
  }
}

k8s_config "grafana_secret" {
  cluster = "k8s_cluster.k3s"
  paths = [
    "./grafana_secret.yaml",
  ]

  wait_until_ready = true
}

helm "grafana" {
  cluster = "k8s_cluster.k3s"

  chart = "github.com/grafana/helm-charts/charts//grafana"
  values = "./grafana_values.yaml"
}

ingress "grafana" {
  target = "k8s_cluster.k3s"
  service = "svc/grafana"

  port {
    local = 80
    remote = 80
    host = 8080
  }
  
  network {
    name = "network.local"
  }
}

k8s_config "prometheus_" {
  depends_on = ["helm.prometheus_stack"]

  cluster = "k8s_cluster.k3s"
  paths = [
    "./prometheus_operator.yaml",
  ]

  wait_until_ready = true
}