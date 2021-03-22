helm "prometheus" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
  
  chart_name = "prometheus"

  chart = "github.com/prometheus-community/helm-charts/charts//kube-prometheus-stack"

  values_string = {
    "alertmanager.enabled" = "false"
    "grafana.enabled" = "false"
  }
  
  health_check {
    timeout = "90s"
    pods = ["release=prometheus"]
  }
}

k8s_config "prometheus" {
  depends_on = ["helm.prometheus"]

  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
  paths = [
    "./k8sconfig/prometheus_operator.yaml",
  ]

  wait_until_ready = true
}

ingress "prometheus" {
  source {
    driver = "local"
    
    config {
      port = var.monitoring_prometheus_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
      address = "prometheus-operated.default.svc"
      port = 9090
    }
  }
}
