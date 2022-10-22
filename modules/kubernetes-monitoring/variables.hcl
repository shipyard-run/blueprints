variable "monitoring_namespace" {
  default = "monitoring"
}

variable "monitoring_helm_values_prometheus" {
  default = "./helm/prometheus_values.yaml"
}

variable "monitoring_helm_values_grafana" {
  default = "./helm/grafana_values.yaml"
}

variable "monitoring_helm_values_tempo" {
  default = "./helm/tempo_values.yaml"
}

variable "monitoring_grafana_port" {
  default = 8080
}

variable "monitoring_tempo_port" {
  default = 3100
}

variable "monitoring_zipkin_port" {
  default = 9411
}

variable "monitoring_prometheus_port" {
  default = 9090
}

variable "monitoring_grafana_version" {
  default = "6.26.5"
}

variable "monitoring_promtail_version" {
  default = "4.2.0"
}

variable "monitoring_loki_version" {
  default = "2.11.1"
}

variable "monitoring_tempo_version" {
  default = "0.14.2"
}

variable "monitoring_prometheus_version" {
  default = "34.10.0"
}

variable "monitoring_grafana_enabled" {
  default = true
}

variable "monitoring_prometheus_enabled" {
  default = true
}

variable "monitoring_loki_enabled" {
  default = true
}

variable "monitoring_tempo_enabled" {
  default = true
}
