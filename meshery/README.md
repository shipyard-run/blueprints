---
title: "Meshery on Kubernetes"
author: "Nic Jackson"
slug: "meshery-k8s"
browser_windows: "http://localhost:8080"
---

This blueprint installs Meshery on K3s in Docker.

## Environment variables
To interact with Kubernetes using `kubectl` you can set the following environment variable:

```
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig.yaml" 
```

## Meshery
Meshery can be run by ponting your browser at:

```
http://localhost:8080
```

For more information on Meshery please see the documentation at 

```
https://meshery.io/#getting-started
```