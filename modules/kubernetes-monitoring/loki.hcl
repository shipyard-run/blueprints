helm "loki" {
  cluster   = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace = var.monitoring_namespace

  chart = "github.com/grafana/helm-charts/charts//loki"
}

helm "promtail" {
  cluster   = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace = var.monitoring_namespace

  chart = "github.com/grafana/helm-charts/charts//promtail"

  values_string = {
    "config.lokiAddress" = "http://loki:3100/loki/api/v1/push"
  }
}