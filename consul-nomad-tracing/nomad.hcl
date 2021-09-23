variable "cn_network" {
  default = "dc1"
}

variable "cn_network" {
  default = "dc1"
}

variable "cn_consul_server_config" {
  default = "${file("${file_dir()}/consul_config/consul.hcl")}"
}

variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

variable "cn_consul_cluster_name" {
  default = "container.consul"
}

variable "cn_consul_open_browser" {
  default = true
}

variable "cn_nomad_open_browser" {
  default = true
}

network "dc1" {
  subnet = "10.15.0.0/16"
}

module "nomad_consul" {
  source = "github.com/shipyard-run/blueprints//modules/consul-nomad?ref=6a60a5088867742e2a9b58e5ed2c42e2611075ca"
  #source = "../modules/consul-nomad"
}
