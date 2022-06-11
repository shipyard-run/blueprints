network "dc1" {
  subnet = "10.15.0.0/24"
}

variable "vault_network" {
  default = "dc1"
}

variable "vault_ip_address" {
  default = "10.15.0.200"
}

module "vault" {
  source = "../"
}
