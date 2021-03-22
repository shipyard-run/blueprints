variable "consul_helm_values" {
  default = "${file_dir()}/helm/consul_values.yaml"
}

variable "consul_api_port" {
  default = 8500
}

variable "consul_rpc_port" {
  default = 8300
}

variable "consul_lan_port" {
  default = 8301
}