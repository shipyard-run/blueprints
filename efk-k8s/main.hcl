network "dc1" {
  subnet = "10.7.0.0/16"
}

variable "efk_k8s_cluster" {
  default = "dc1"
}

k8s_cluster "dc1" {
  driver = "k3s"
  network {
    name = "network.dc1"
  }
}

module "efk-stack" {
  source = "./modules/kubernetes-efk-stack"
  depends_on = ["k8s_cluster.dc1"]
}

output "KUBECONFIG" {
  value = k8s_config("dc1")
}
