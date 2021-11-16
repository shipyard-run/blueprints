helm "tempo" {
  cluster   = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace = var.monitoring_namespace

  chart  = "github.com/grafana/helm-charts/charts//tempo"
  values = var.monitoring_helm_values_tempo
}

ingress "tempo" {
  source {
    driver = "local"

    config {
      port = var.monitoring_tempo_port
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
      address = "tempo.default.svc"
      port    = 3100
    }
  }
}

ingress "zipkin" {
  source {
    driver = "local"

    config {
      port = var.monitoring_zipkin_port
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
      address = "tempo.${var.monitoring_namespace}.svc"
      port    = 9411
    }
  }
}