variable "cd_consul_server_instances" {
  default = 1
}

variable "cd_consul_network" {
  default = var.cn_network
}

module "consul" {
  source = "github.com/shipyard-run/blueprints?ref=62a250e3af082e721e7b45dc8f87b31634579329/modules//consul-docker"
}
