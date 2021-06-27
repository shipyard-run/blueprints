variable "consul_k8s_network" {
  default = "dc1"
}

variable "consul_k8s_cluster" {
  default = "dc1"
}

variable "consul_monitoring_enabled" {
  default = "true"
}

variable "consul_smi_controller_enabled" {
  default = "true"
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

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

module "kubernetes_consul" {
  source = "github.com/shipyard-run/blueprints/modules//kubernetes-consul"
  //source = "../modules/kubernetes-consul"
}
