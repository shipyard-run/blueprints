variable "consul_k8s_cluster" {
  default = "kubernetes"
}

variable "consul_k8s_network" {
  default = "local"
}

variable "consul_datacenter" {
  default = "kubernetes"
}

variable "consul_gateway_enabled" {
  description = "Should mesh gateways be enabled?"
  default = true
}

variable "consul_gateway_address" {
  default = "10.5.0.200"
}

variable "consul_federation_enabled" {
  description = "Should a federation secret be created?"
  default = true
}

variable "consul_federation_create_secret" {
  description = "Should a federation secret be created?"
  default = true
}

variable "consul_tls_enabled" {
  default = true
}

variable "consul_ports_gateway" {
  default = 30443
}

network "local" {
  subnet = "10.5.0.0/16"
}

k8s_cluster "kubernetes" {
  driver  = "k3s"

  nodes = 1

  network {
    name = "network.local"
    ip_address = "10.5.0.200"
  }
}

output "KUBECONFIG" {
  value = k8s_config("kubernetes")
}

module "consul" {
  source = var.consul_k8s_module
}