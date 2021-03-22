variable "consul_k8s_cluster" {
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

module "consul" {
  source = "../"
}
