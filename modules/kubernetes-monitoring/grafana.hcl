template "grafana_secret_template" {
  source      = file("./k8sconfig/grafana_secret.yaml")
  destination = "${data("monitoring")}/grafana_secret.yaml"

  vars = {
    monitoring_namespace = var.monitoring_namespace
  }
}

k8s_config "grafana_secret" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
  depends_on = [
    "template.grafana_secret_template",
    "k8s_config.monitoring_namespace",
  ]

  paths = [
    "${data("monitoring")}/grafana_secret.yaml",
  ]

  wait_until_ready = true
}

helm "grafana" {
  depends_on = ["helm.tempo"]

  cluster          = "k8s_cluster.${var.monitoring_k8s_cluster}"
  namespace        = var.monitoring_namespace
  create_namespace = true

  repository {
    url  = "https://grafana.github.io/helm-charts"
    name = "grafana"
  }

  chart   = "grafana/grafana"
  version = var.monitoring_grafana_version

  values = var.monitoring_helm_values_grafana

  values_string = {
    "admin.existingSecret" = "grafana-password"
  }
}

ingress "grafana" {
  source {
    driver = "local"

    config {
      port = var.monitoring_grafana_port
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"
      address = "grafana.${var.monitoring_namespace}.svc"
      port    = 80
    }
  }
}
