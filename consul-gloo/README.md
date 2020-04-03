---
title: "Service Mesh for Developers"
author: "Nic Jackson, Christian Posta"
slug: "consul-solo"
browser_windows: "http://localhost:18081,http://localhost:18500,http://localhost:18443,http://localhost:16686"
---
This example shows how you can use Gloo from Solo.io with Consul

## Environment variables

```shell
export CONSUL_HTTP_ADDR=http://localhost:18500
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig.yml"
```

Open your browser at `http://localhost:8500` to access the Consul UI