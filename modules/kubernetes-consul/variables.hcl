variable "consul_helm_values" {
  default = "${file_dir()}/helm/consul_values.tmpl"
}

variable "consul_api_port" {
  default = 8500
}

variable "consul_rpc_port" {
  default = 8300
}

variable "consul_lan_port" {
  default = 8301
}

variable "consul_enable_acls" {
  default = false
}

variable "consul_enable_tls" {
  default = false
}

variable "consul_enable_monitoring" {
  description = "Should the monitoring stack, Prometheus, Grafana, Loki be installed"
  default = false
}

variable "consul_grafana_port" {
  description = "Port for grafana when monitoring enabled"
  default = 8080
}

variable "consul_prometheus_port" {
  description = "Port for prometheus when monitoring enabled"
  default = 9090
}

variable "consul_enable_smi_controller" {
  description = "Should the SMI controller be installed"
  default = false
}

variable "consul_smi_controller_repository" {
  description = "Repository for the controller image"
  default = "nicholasjackson/consul-smi-controller"
}

variable "consul_smi_controller_tag" {
  description = "Tag for the controller image"
  default = "latest"
}

# Variables for Monitoring module
variable "monitoring_k8s_cluster" {
  description = "Cluster to install monitoring, should be the same as the cluster for installing Consul"
  default = var.consul_k8s_cluster 
}

variable "monitoring_grafana_port" {
   description = "Set the monitoring module grafana port varaible, we do not expose this variable publically to cover interface changes"
   default = var.consul_grafana_port
}

variable "monitoring_prometheus_port" {
   description = "Set the monitoring module grafana port varaible, we do not expose this variable publically to cover interface changes"
   default = var.consul_prometheus_port
}

# Variables for SMI-Controller module
variable "smi_controller_k8s_cluster" {
  description = "Set the cluster to install the SMI controller to, we do not expose this variable publically to cover interface changes"
  default = var.consul_k8s_cluster
}

variable "smi_controller_repository" {
  description = "Repository for the controller image"
  default = var.consul_smi_controller_repository
}

variable "smi_controller_tag" {
  description = "Tag for the controller image"
  default = var.consul_smi_controller_tag
}
