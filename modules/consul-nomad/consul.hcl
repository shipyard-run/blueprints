variable "cd_consul_server_instances" {
  default = 1
}

variable "cd_consul_network" {
  default = var.cn_network
}

module "consul" {
  source = "github.com/shipyard-run/blueprints?ref=5635f282cd28bcd2213494e558bf2151d10c7e9c/modules//consul-docker"
}
