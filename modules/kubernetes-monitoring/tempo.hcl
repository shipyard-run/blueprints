helm "tempo" {
  disabled = !var.monitoring_tempo_enabled

  depends_on = ["helm.promtail"]

  cluster          = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace        = var.monitoring_namespace
  create_namespace = true


  repository {
    url  = "https://grafana.github.io/helm-charts"
    name = "grafana"
  }

  chart   = "grafana/tempo"
  version = var.monitoring_tempo_version

  values = var.monitoring_helm_values_tempo
}

ingress "tempo" {
  disabled = !var.monitoring_tempo_enabled

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
  disabled = !var.monitoring_tempo_enabled

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
