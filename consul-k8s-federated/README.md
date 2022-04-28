---
title: "Federated Consul Service Mesh on Kubernetes and Linux"
author: "Nic Jackson"
slug: "consul-k8s-federated"
---

This blueprint two Kubernetes clusters with Consul Service Mesh federated together.

# Consul UI / API
To access the Consul UI for the Kubernetes cluster, open `http://localhost:8501` in your browser.
To access the Consul UI for the Linux cluster, open `http://localhost:18500` in your browser.

This application exposes two endpoints:

http://localhost:19091 Source traffic in Kubernetes with an upstream running on Linux
http://localhost:19092 Source traffic in Linux with an upstream running on Kubernetes

# Cleanup
To clean up run `shipyard destroy`