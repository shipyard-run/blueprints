helm "loki" {
  depends_on = ["helm.prometheus"]

  cluster          = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace        = var.monitoring_namespace
  create_namespace = true

  repository {
    url  = "https://grafana.github.io/helm-charts"
    name = "grafana"
  }

  chart   = "grafana/loki"
  version = var.monitoring_loki_version
}

helm "promtail" {
  depends_on = ["helm.loki"]

  cluster          = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace        = var.monitoring_namespace
  create_namespace = true

  repository {
    url  = "https://grafana.github.io/helm-charts"
    name = "grafana"
  }

  chart   = "grafana/promtail"
  version = var.monitoring_promtail_version

  values_string = {
    "config.lokiAddress" = "http://loki:3100/loki/api/v1/push"
  }
}