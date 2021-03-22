---
title: "Consul and Nomad"
author: "Anubhav Mishra"
slug: "consul-nomad"
---

This module runs a Consul and Nomad cluster configured to with Consul Service Mesh.

The following resources are created:
* Consul Server x1
* Nomad servers x1
* Nomad clients x3

## Required Variables

To use this blueprint you need to set the following variables:

```
# Name of the network the cluster will be attached to (not created)
variable "cn_networkd" {
  default = "dc1"
}
```

## Optional Variables

Optionally the following variables can be set:

```javascript
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
  default = "local"
}

# Default Consul config, can be overridden by setting this variable from outside
# the module
variable "cn_consul_server_config" {
  default = "${file("${file_dir()}/consul_config/consul.hcl")}"
}
```

## Output variables

The module will set the following output variables:

```javascript
# Address where the nomad client can reach the Nomad server API
output "NOMAD_ADDR" {
  value = cluster_api("nomad_cluster.local")
}

output "CONSUL_HTTP_ADDR" {
  value = "http://localhost:18500"
}
```

## Example:

```javascript
// set the variable for the network
variable "cn_network" {
  default = "dc1"
}

network "dc1" {
  subnet = "10.5.0.0/16"
}

module "consul_nomad" {
  source = "../"
}

nomad_job "jobs" {
  cluster = "nomad_cluster.${var.cn_nomad_cluster_name}"
  paths = [
    "./web.nomad",
    "./api.nomad",
  ]
}

nomad_ingress "web" {
  cluster = "nomad_cluster.${var.cn_nomad_cluster_name}"
  job = "web"
  group = "web"
  task = "web"
  
  network {
    name = "network.dc1"
  }

  port {
    local  = 9090
    remote = "http"
    host   = 19090
  }
}
```