variable "monitoring_helm_values_grafana" {
   default = "./helm/grafana_values.yaml" 
}

variable "monitoring_grafana_port" {
   default = 8080
}

variable "monitoring_prometheus_port" {
   default = 9090
}