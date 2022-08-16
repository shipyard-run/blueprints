variable "cd_consul_version" {
  default = "1.12.2"
}

variable "cd_gateway_enabled" {
  default = false
}

variable "cd_gateway_version" {
  default = "v1.12.2-v1.20.1"
}

variable "cd_gateway_ip" {
  default = "10.5.0.202"
}

variable "cd_consul_server_instances" {
  default = 3
}

variable "cd_consul_dc" {
  default = "dc1"
}

variable "cd_consul_primary_dc" {
  default = "dc1"
}

variable "cd_consul_data" {
  default = data("consul")
}

variable "cd_consul_certs_data" {
  default = data("certs")
}

variable "cd_consul_ports" {
  default = {
    rpc      = 8300
    lan-serf = 8301
    wan-serf = 8302
    http     = 8500
    https    = 8501
    grpc     = 8502
    dns      = 8600
  }
}

variable "cd_consul_acls_enabled" {
  default = false
}

variable "cd_consul_tls_enabled" {
  default = false
}

variable "cd_consul_tls_protocol" {
  default = var.cd_consul_tls_enabled ? "https" : "http"
}

variable "cd_consul_api_port" {
  default = var.cd_consul_tls_enabled ? 8501 : 8500
}

# Additional volume to add to the server
variable "cd_consul_additional_volume" {
  default = {
    source      = ""
    destination = "/data"
    type        = "tmpfs"
  }
}

# Must be set or blueprint will not function
variable "cd_consul_network" {
  default = ""
}
