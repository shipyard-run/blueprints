---
title: "Meshery on Kubernetes"
author: "Nic Jackson"
slug: "meshery-k8s"
browser_windows: "http://meshery.ingress.shipyard.run:8080"
---

This blueprint installs Meshery on K3s in Docker.

**Requires Shipyard version: 0.0.18**

## Environment variables
To interact with Kubernetes using `kubectl` you can set the following environment variable:

```
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig.yaml" 
```

## Meshery
Meshery can be run by ponting your browser at:

```
http://meshery.ingress.shipyard.run:8080
```

For more information on Meshery please see the documentation at 

```
https://meshery.io/#getting-started
```