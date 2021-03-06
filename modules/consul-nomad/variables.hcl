# Number of client nodes for Nomad
# setting this value to 0 runs a combined Nomad Client/Server in a single
# container.
variable "cn_nomad_client_nodes" {
  default = 3
}

# Image to use for Consul server
variable "cn_consul_image" {
  default = "consul"
}

# Version of Consul for the server
variable "cn_consul_version" {
  default = "1.9.4"
}

# Port to expose the Consul server
variable "cn_consul_port" {
  default = 18500
}

# Nomad version to use
variable "cn_nomad_version" {
  default = "0.11.8"
}

# Name of the cluster, changing this value does not 
# affect the name of the cluster as shipyard does 
# not yet support this feature
variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

variable "cn_consul_cluster_name" {
  default = "container.consul"
}

# Default Consul config, can be overridden by setting this variable from outside
# the module
variable "cn_consul_server_config" {
  default = "${file("${file_dir()}/consul_config/consul.hcl")}"
}

# Address where the nomad client can reach the Nomad server API
output "NOMAD_ADDR" {
  value = cluster_api("nomad_cluster.local")
}

output "CONSUL_HTTP_ADDR" {
  value = "http://localhost:18500"
}