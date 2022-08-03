network "local" {
  subnet = "10.10.0.0/16"
}

variable "cd_consul_network" {
  default = "local"
}

variable "cd_consul_acls_enabled" {
  default = true
}

variable "cd_consul_tls_enabled" {
  default = true
}

module "consul" {
  source = "../"
}
