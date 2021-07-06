---
title: "Federated Consul Service Mesh on Kubernetes"
author: "Nic Jackson"
slug: "consul-k8s-federated"
---

This blueprint two Kubernetes clusters with Consul Service Mesh federated together.

NOTE: This blueprint is Work in Progress

# Environment Variables
To use `kubectl` or the `consul` CLI please set the following environment variables:

```shell
export KUBECONFIG="$HOME/.shipyard/config/dc1/kubeconfig.yaml"
export CONSUL_HTTP_ADDR="https://localhost:8501"
export CONSUL_HTTP_TOKEN_FILE="$PWD/files/acl_token.txt"
export CONSUL_CACERT="$PWD/files/ca.pem"
```

# Consul UI / API
To access the Consul UI open `http://localhost:8501` in your browser.
You can also use this address to interact with the Consul API.

# Cleanup
To clean up run `shipyard destroy`