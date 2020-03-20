---
title: HashiCorp Vault and Kubernetes 
author: Nic Jackson
slug: vault_k8s
browser_windows: http://localhost:18200,http://localhost:18443,http://localhost:18080
---

This blueprint creates a Kubernetes cluster with Vault Helm chart installed

## Environment Variables 

To interact with the setup from your local machine you will need `kubectl` the Vault CLI
and the following environment variables need to be set.

```shell
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig.yaml"
export VAULT_ADDR="http://localhost:18200"
export VAULT_TOKEN="root"
```

## Vault UI
To access the Vault UI point your browser at:

`http://localhost:18200`

The token `root` can be used to authenticate

## Kubernetes Dashboard
The Kubernetes dashboard is automatically installed and can be accessed at:

`http://localhost:18443`

When prompted press skip to ignore the authentication request

## Interactive Documentation
To view the interactive documentation and walk through of using Vault Dynmamic secrets with PostgresSQL
please check out the docs at:


`http://localhost:18080`
  
## Cleanup

Run `yard delete` to cleanup all resources

## Components
* Kubernetes
* HashiCorp Vault (installed with Helm)
* Example walkthrough for dynamic secrets