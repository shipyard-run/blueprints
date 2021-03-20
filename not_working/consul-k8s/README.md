---
title: "Consul Service Mesh on Kubernetes"
author: "Nic Jackson"
slug: "consul-k8s"
browser_windows: "http://localhost:18500"
---

This blueprint runs Kubernetes using Rancher K3s and installs Consul Service Mesh
using the Consul Helm chart.

# Environment Variables
To use `kubectl` or the `consul` CLI please set the following environment variables:

```shell
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig.yaml"
export CONSUL_HTTP_ADDR="http://localhost:18500"
```

# Consul UI / API
To access the Consul UI open `http://localhost:18500` in your browser.
You can also use this address to interact with the Consul API.

# Cleanup
To clean up run `shipyard destroy`