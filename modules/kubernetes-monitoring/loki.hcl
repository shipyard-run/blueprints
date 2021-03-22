helm "loki" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"

  chart = "github.com/grafana/helm-charts/charts//loki"
}

helm "promtail" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"

  chart = "github.com/grafana/helm-charts/charts//promtail"
  
  values_string = {
    "loki.serviceName" = "loki"
    "grafana.enabled" = "false"
  }
}
