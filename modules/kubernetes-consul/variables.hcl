variable "consul_data_folder" {
  description = "Data folder where output files including TLS certificates will be stored"
  default = data("consul_kubernetes")
}

variable "consul_helm_values" {
  default = "${file_dir()}/helm/consul_values.yaml"
}

variable "consul_ports_api" {
  default = 0
}

variable "consul_ports_rpc" {
  default = 8300
}

variable "consul_ports_lan" {
  default = 8301
}

variable "consul_ports_gateway" {
  default = 1443
}

variable "consul_acls_enabled" {
  default = false
}

variable "consul_tls_enabled" {
  default = false
}

variable "consul_datacenter" {
  default = "dc1"
}

variable "consul_monitoring_enabled" {
  description = "Should the monitoring stack, Prometheus, Grafana, Loki, and Tempo be installed?"
  default = false
}

variable "consul_monitoring_grafana_port" {
  description = "Port for grafana when monitoring enabled"
  default = 8080
}

variable "consul_monitoring_prometheus_port" {
  description = "Port for prometheus when monitoring enabled"
  default = 9090
}

variable "consul_smi_controller_enabled" {
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

# Variables for Mesh Gateways
variable "consul_gateway_enabled" {
  description = "Enable mesh gateways"
  default = false
}

variable "consul_gateway_address" {
  description = "Wan address for the mesh gateway"
  default = "${var.consul_k8s_cluster}.k8s-cluster.shipyard.run"
}

variable "consul_federation_enabled" {
  description = "Enable federation, required to use mesh gateways"
  default = false
}

variable "consul_federation_create_secret" {
  description = "Create a federation secret?"
  default = false
}

# Variables for Monitoring module
variable "monitoring_k8s_cluster" {
  description = "Cluster to install monitoring, should be the same as the cluster for installing Consul"
  default = var.consul_k8s_cluster 
}

variable "monitoring_grafana_port" {
   description = "Set the monitoring module grafana port varaible, we do not expose this variable publically to cover interface changes"
   default = var.consul_monitoring_grafana_port
}

variable "monitoring_prometheus_port" {
   description = "Set the monitoring module grafana port varaible, we do not expose this variable publically to cover interface changes"
   default = var.consul_monitoring_prometheus_port
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
