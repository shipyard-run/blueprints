variable "cd_consul_server_instances" {
  default = 1
}

variable "cd_consul_network" {
  default = var.cn_network
}

module "consul" {
  source = "github.com/shipyard-run/blueprints/modules//consul-docker"
}
