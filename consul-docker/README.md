---
title: "Consul on Docker"
author: "Nic Jackson"
slug: "consul-docker"
env:
  - CONSUL_HTTP_ADDR=http://localhost:18500
---

# Accessing Consul

## In your browser

Open your browser at `http://localhost:18500` to access the Consul UI

## Using the Consul CLI

Set the `CONSUL_HTTP_ADDR` environment variable

```
export CONSUL_HTTP_ADDR=http://localhost:18500
```

## Shell

You can use Shipyard to enter an interactive terminal for the Consul server

```
shipyard shell container.consul_1
```