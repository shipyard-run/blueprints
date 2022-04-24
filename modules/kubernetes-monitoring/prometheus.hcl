k8s_config "prometheus-crds" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
  paths = [
    "./helm/prometheus-crds",
  ]

  wait_until_ready = true
}

helm "prometheus" {
  depends_on       = ["k8s_config.prometheus-crds"]
  cluster          = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace        = var.monitoring_namespace
  create_namespace = true

  repository {
    url  = "https://prometheus-community.github.io/helm-charts"
    name = "prometheus"
  }

  chart   = "prometheus/kube-prometheus-stack"
  version = var.monitoring_prometheus_version
  values  = var.monitoring_helm_values_prometheus


  health_check {
    timeout = "90s"
    pods    = ["app.kubernetes.io/name=prometheus"]
  }
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
      address = "prometheus-operated.${var.monitoring_namespace}.svc"
      port    = 9090
    }
  }
}