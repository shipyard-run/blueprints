---
title: "Consul and Nomad"
author: "Anubhav Mishra"
slug: "consul-nomad"
browser_windows: "http://localhost:14646,http://localhost:18600"
---

This blueprint comprises of Consul and Nomad

## Set the following environment variables to interact with this blueprint 

```
export NOMAD_ADDR="http://localhost:14646"
export CONSUL_HTTP_ADDR="http://localhost:18600"
 ``` 

## Consul UI
   Open `http://localhost:18600` to access the Consul UI
 
## Nomad UI
   Open `http://localhost:14646` to access the Nomad UI

## Cleanup
   Run `shipyard destroy` to cleanup all resources