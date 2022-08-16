variable "cd_consul_acls_enabled" {
  default = false
}

variable "cd_consul_tls_enabled" {
  default = true
}

variable "cd_consul_dc" {
  default = "vms"
}

variable "cd_consul_primary_dc" {
  default = "vms"
}

variable "cd_consul_network" {
  default = "local"
}

variable "cd_gateway_enabled" {
  default = true
}

variable "cd_gateway_ip" {
  default = "10.10.0.202"
}

network "local" {
  subnet = "10.10.0.0/16"
}

variable "cd_consul_additional_volume" {
  default = {
    source      = data("agent_config")
    destination = "/files"
    type        = "bind"
  }
}

module "vms" {
  source = var.consul_docker_module
}
