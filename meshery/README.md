---
title: "Meshery on Kubernetes"
author: "Nic Jackson"
slug: "meshery-k8s"
env:
  - KUBECONFIG=$HOME/.shipyard/config/k3s/kubeconfig.yaml
shipyard_version: ">= 0.2.0"
---

This blueprint installs Meshery on K3s with Promethus and Grafana.

## Meshery
Meshery can be run by pointing your browser at:

```
http://meshery.ingress.shipyard.run:9081
```

For more information on Meshery please see the documentation at 

```
https://meshery.io/#getting-started
```
