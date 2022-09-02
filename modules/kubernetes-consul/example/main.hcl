variable "consul_health_check_timeout" {
  default     = "240s"
  description = "Increase the timeout for when running on CI, Consul startup can take longer due to limited resources"
}

# Mandatory varirables
variable "consul_k8s_cluster" {
  default = "dc1"
}

variable "consul_k8s_network" {
  default = "dc1"
}
# Mandatory variables

# Optionally you can set the following variables to enable submodules
# for installing monitoring tools or the SMI controller for Consul.
# 
variable "consul_monitoring_enabled" {
  description = "Should the monitoring stack, Prometheus, Grafana, Loki be installed"
  default     = true
}

variable "consul_smi_controller_enabled" {
  description = "Should the SMI controller be installed"
  default     = false
}

variable "consul_release_controller_enabled" {
  description = "Enable the consul release controller?"
  default     = true
}

variable "consul_acls_enabled" {
  description = "Enable ACLs for securing the Consul server"
  default     = true
}

variable "consul_tls_enabled" {
  description = "Enable TLS to secure the Consul server"
  default     = true
}

variable "consul_ingress_gateway_enabled" {
  description = "Should ingress gateways be enabled?"
  default     = true
}

variable "consul_mesh_gateway_enabled" {
  description = "Should mesh gateways be enabled?"
  default     = false
}

variable "consul_mesh_gateway_create_federation_secret" {
  description = "Should a federation secret be created?"
  default     = false
}

variable "consul_transparent_proxy_enabled" {
  description = "Enable the transparent proxy feature for then entire cluster for consul service mesh"
  default     = true
}

variable "consul_auto_inject_enabled" {
  description = "Enable the automatic injection of sidecar proxies for kubernetes pods"
  default     = true
}

variable "consul_auto_inject_deny_namespaces" {
  description = "List of Kubernetes namespaces where auto inject is ignored"
  default     = ["monitoring"]
}
# End optional variables

k8s_cluster "dc1" {
  driver = "k3s"

  nodes = 1

  network {
    name = "network.dc1"
  }
}

output "KUBECONFIG" {
  value = k8s_config("dc1")
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

module "consul" {
  source = "../"
}

k8s_config "app" {
  depends_on = ["module.consul"]

  cluster = "k8s_cluster.dc1"
  paths = [
    "./app/consul-config.yaml",
    "./app/api.yaml",
    "./app/payments.yaml",
    "./app/currency.yaml",
  ]

  wait_until_ready = true
}

ingress "public" {
  source {
    driver = "local"

    config {
      port = 19090
    }
  }

  destination {
    driver = "k8s"

    config {
      cluster = "k8s_cluster.dc1"
      address = "api.default.svc"
      port    = 9090
    }
  }
}
