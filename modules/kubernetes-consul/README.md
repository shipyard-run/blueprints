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

* consul_api_port    - default 8500
* consul_rpc_port    - default 8300
* consul_lan_port    - default 8301
* consul_enable_acls - default false: Enable ACL system for Consul
* consul_enable_tls  - default false: Enable TLS for Consul

# Outputs

* CONSUL_HTTP_ADDR    - Address of the Consul ingress
* CONSUL_TOKEN_FILE   - Location of Consuls bootstrap ACL token, when consul_enable_acls is true
* CONSUL_CA_CERT_FILE - Location of Consuls CA certificate, when consul_enable_tls is true
* CONSUL_CA_KEY_FILE  - Location of Consuls CA key, when consul_enable_tls is true

## Usage

This module can be consumed by using the module stanza

```
module "consul" {
  source = "./module_path_or_github"
}
```