# Module to install SMI Controller

This module installs the SMI controller using the default Helm chart.

## Created resources
* SMI Controller Helm Chart

## Required Variables

To use this module the following resources are required:

* smi_controller_k8s_cluster - name of the Kubernetes cluster to deploy the resources

## Optional Variables

Optionally you can set the following variables:

* smi_controller_repository - default: nicholasjackson/smi-controller-example
* smi_controller_tag - default: dev
* smi_controller_helm_values - default: default value file

## Usage

This module can be consumed by using the module stanza

```
module "smi_controller" {
  source = "./module_path_or_github"
}
```