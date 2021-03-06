variable "consul_k8s_cluster" {
  default = "dc1"
}

variable "consul_k8s_network" {
  default = "dc1"
}

# Optionally you can set the following variables to enable submodules
# for installing monitoring tools or the SMI controller for Consul.
# 
##variable "consul_monitoring_enabled" {
##  description = "Should the monitoring stack, Prometheus, Grafana, Loki be installed"
##  default = true
##}
# 
# variable "consul_smi_controller_enabled" {
#   description = "Should the SMI controller be installed"
#   default = true
# }

#variable "consul_gateway_enabled" {
#  description = "Should mesh gateways be enabled?"
#  default = true
#}
#
#variable "consul_gateway_create_federation_secret" {
#  description = "Should a federation secret be created?"
#  default = true
#}

k8s_cluster "dc1" {
  driver  = "k3s"

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
  depends_on = ["module.monitoring"]

  cluster = "k8s_cluster.dc1"
  paths = [
    "./app/api.yaml",
    "./app/payments.yaml",
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
      address = "public.default.svc"
      port = 9090
    }
  }
}
