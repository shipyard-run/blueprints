helm "tempo" {
  cluster = "k8s_cluster.${var.monitoring_k8s_cluster}"

  chart = "github.com/grafana/helm-charts/charts//tempo"
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
      port = 3100
    }
  }
}
