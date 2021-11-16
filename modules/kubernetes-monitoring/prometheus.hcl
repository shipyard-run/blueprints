template "prometheus_operator_template" {
  source      = file("./k8sconfig/prometheus_operator.yaml")
  destination = "${data("monitoring")}/prometheus_operator.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

helm "prometheus" {
  cluster   = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace = var.monitoring_namespace

  chart_name = "prometheus"

  chart = "github.com/prometheus-community/helm-charts/charts//kube-prometheus-stack"

  values_string = {
    "alertmanager.enabled" = "false"
    "grafana.enabled"      = "false"
  }

  health_check {
    timeout = "90s"
    pods    = ["release=prometheus"]
  }
}

k8s_config "prometheus" {
  depends_on = ["helm.prometheus"]

  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
  paths = [
    "${data("monitoring")}/prometheus_operator.yaml",
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
      address = "prometheus-operated.${var.monitoring_namespace}.svc"
      port    = 9090
    }
  }
}