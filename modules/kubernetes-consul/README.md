---
title: "HashiCorp Consul and Kubernetes"
author: "Nic Jackson"
slug: "consul_k8s"
---

# Module to install Kubernetes and Consul Service Mesh

This module creates a Kubernetes cluster and installs and configures
Consul Service Mesh with CRDs enabled.

## Created resources
* Kubernetes cluster
* Consul Helm Chart
* Consul Ingress exposing ports 8500, 8300, and 8301

## Required Variables

To use this module the following resources are required:

* consul_k8s_cluster - name of the kubernetes cluster the resources should be provisioned to
* consul_k8s_network - name of the network the resources should be attached to

## Optional Variables

Optionally you can set the following variables to change the default
ingress ports

* consul_ports_api                  - default 8500, 8501 when https enabled
* consul_ports_rpc                  - default 8300
* consul_ports_lan                  - default 8301
* consul_ports_gateway              - default 1443
* consul_acls_enabled               - default false: Enable ACL system for Consul
* consul_tls_enabled                - default false: Enable TLS for Consul
* consul_monitoring_enabled         - default false: Install Prometheus, Grafana, Loki monitoring stack
* consul_monitoring_grafana_port    - default: 8080
* consul_monitoring_prometheus_port - default 8080
* consul_enable_smi_controller      - default false: Install the Consul SMI Controller
* consul_smi_controller_repository  - default nicholasjackson/consul-smi-controller
* consul_smi_controller_tag         - default latest

# Outputs

* CONSUL_HTTP_ADDR    - Address of the Consul ingress
* CONSUL_TOKEN_FILE   - Location of Consuls bootstrap ACL token, when consul_enable_acls is true
* CONSUL_CA_CERT_FILE - Location of Consuls CA certificate, when consul_enable_tls is true
* CONSUL_CA_KEY_FILE  - Location of Consuls CA key, when consul_enable_tls is true

When `consul_enable_monitoring` is set to true the following outputs are set:
* GRAFANA_HTTP_ADDR    - Address of the Grafana server
* GRAFANA_USER         - Username for Grafana
* GRAFANA_PASSWORD     - Password for Grafana
* PROMETHEUS_HTTP_ADDR - Address for the Prometheus server

## Usage

This module can be consumed by using the module stanza

```javascript
variable "consul_k8s_cluster" {
  default = "dc1"
}

variable "consul_k8s_network" {
  default = "dc1"
}

k8s_cluster "dc1" {
  driver  = "k3s"

  nodes = 1

  network {
    name = "network.dc1"
  }
}

module "consul" {
  source = "github.com/shipyard-run/blueprints/modules/kubernetes-consul"
}
```
