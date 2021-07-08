---
title: "HashiCorp Vault and Kubernetes"
author: "Nic Jackson"
slug: "vault_k8s"
---

This blueprint creates a Kubernetes cluster with Vault Helm chart installed

## Vault UI
To access the Vault UI point your browser at:

`http://vault.ingress.shipyard.run:8200`

The token `root` can be used to authenticate

## Interactive Documentation
To view the interactive documentation and walk through of using Vault Dynmamic secrets with PostgresSQL
please check out the docs at:

`http://docs.docs.shipyard.run:18080`
  
## Cleanup

Run `shipyard destroy` to cleanup all resources

## Components
* Kubernetes
* HashiCorp Vault (installed with Helm)
* Example walkthrough for dynamic secrets
