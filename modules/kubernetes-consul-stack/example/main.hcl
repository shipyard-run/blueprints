variable "consul_kubernetes_network" {
  default = "dc1"
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

module "consul_stack" {
  source = "../"
}
