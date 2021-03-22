variable "vault_k8s_cluster" {
  default = "dc1"
}

k8s_cluster "dc1" {
  driver  = "k3s"
  version = "v1.0.1"

  nodes = 1

  network {
    name = "network.dc1"
  }
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

module "vault" {
  source = "../"
}

output "KUBECONFIG" {
  value = k8s_config("dc1")
}