variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

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

variable "cn_consul_version" {
  default = "1.12.2"
}

# Port to expose the Consul server
variable "cn_consul_port" {
  default = 18500
}

variable "cn_consul_datacenter" {
  default = "dc1"
}

# Nomad version to use
variable "cn_nomad_version" {
  default = "1.3.1"
}

# Name of the cluster, changing this value does not 
# affect the name of the cluster as shipyard does 
# not yet support this feature
variable "cn_nomad_cluster_name" {
  default = "nomad_cluster.local"
}

variable "cn_consul_cluster_name" {
  default = "1-consul-server.container.shipyard.run"
}

# Default Consul config, can be overridden by setting this variable from outside
# the module
variable "cn_consul_agent_config" {
  default = file("${file_dir()}/consul_config/agent.hcl")
}

# Default Consul config for the nomad agents
variable "cn_nomad_consul_agent_config" {
  default = "${data("consul_config")}/agent.hcl"
}

# Path to additional Nomad client config to merge to client nodes
variable "cn_nomad_client_config" {
  default = ""
}

# Path to additional Nomad server config to merge to server nodes
variable "cn_nomad_server_config" {
  default = ""
}

# Host volume to mount to the Nomad client nodes
variable "cn_nomad_client_host_volume" {
  default = {
    name        = ""
    source      = ""
    destination = "/data"
    type        = "tempfs"
  }
}

# Add insecure registries to the Docker daemon config
# allows the use of registries with self signed certificates
variable "cn_nomad_docker_insecure_registries" {
  default = []
}

# Copy a local image to the nomad clusters docker cache
variable "cn_nomad_load_image" {
  default = ""
}

variable "cn_consul_open_browser" {
  default = false
}

variable "cn_nomad_open_browser" {
  default = false
}

# Must be set 
variable "cn_network" {
  default = ""
}

# Address where the nomad client can reach the Nomad server API
output "NOMAD_ADDR" {
  value = cluster_api("nomad_cluster.local")
}

output "CONSUL_HTTP_ADDR" {
  value = "http://localhost:18500"
}

# Enable setting a custom server ip address
# currently only works when not using client nodes
variable "cn_nomad_server_ip" {
  default = ""
}
