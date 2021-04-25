output "GRAFANA_HTTP_ADDR" {
  value = "localhost:${var.monitoring_grafana_port}"
}

output "GRAFANA_USER" {
  value = "admin"
}

output "GRAFANA_PASSWORD" {
  value = "admin"
}

output "PROMETHEUS_HTTP_ADDR" {
  value = "localhost:${var.monitoring_prometheus_port}"
}
