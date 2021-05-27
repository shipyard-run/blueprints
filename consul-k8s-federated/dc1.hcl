variable "consul_k8s_cluster" {
  default = "dc1"
}

variable "consul_k8s_network" {
  default = "local"
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

k8s_cluster "dc1" {
  driver  = "k3s"

  nodes = 1

  network {
    name = "network.local"
    ip_address = "10.5.0.200"
  }
}

output "KUBECONFIG" {
  value = k8s_config("dc1")
}

module "consul" {
  source = var.consul_k8s_module
}

#k8s_ingress "gateway-dc1" {
#  cluster = "k8s_cluster.dc1"
#
#  network {
#    name = "network.dc1"
#  }
#  
#  network {
#    name = "network.wan"
#    ip_address = "192.168.0.200"
#  }
#  
#  network {
#    name = "network.wan"
#  }
#
#  service  = "consul-mesh-gateway"
#
#  port {
#    local  = 443
#    remote = 443
#  }
#}

#exec_remote "configure" {
#  depends_on = ["helm.dc1","k8s_cluster.dc2"]
#
#  image {
#    name = "shipyardrun/tools:latest"
#  }
#  
#  network {
#    name = "network.dc1"
#  }
#  
#  network {
#    name = "network.dc2"
#  }
#  
#  cmd = "bash"
#  args = [
#    "-c",
#    "/files/get_consul_details.sh",
#  ]
#
#  volume {
#    source = "${k8s_config("dc1")}"
#    destination = "/config_dc1.yaml"
#  }
#  
#  volume {
#    source = "${k8s_config("dc2")}"
#    destination = "/config_dc2.yaml"
#  }
#  
#  volume {
#    source = "./files"
#    destination = "/files"
#  }
#}
