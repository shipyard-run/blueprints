variable "monitoring_namespace" {
  default = "monitoring"
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
  default = "6.21.2"
}

variable "monitoring_promtail_version" {
  default = "3.11.0"
}

variable "monitoring_loki_version" {
  default = "2.9.1"
}

variable "monitoring_tempo_version" {
  default = "0.13.1"
}

variable "monitoring_prometheus_version" {
  default = "32.0.0"
}