---
title: "Consul and Nomad"
author: "Anubhav Mishra"
slug: "consul-nomad"
---

This blueprint comprises of Consul and Nomad.  It stands up service mesh endpoints and sends tracing data to Jaeger.   

## Set the following environment variables to interact with this blueprint 

```
export NOMAD_ADDR="http://localhost:14646"
export CONSUL_HTTP_ADDR="http://localhost:18600"
 ``` 

## Consul UI
   Open `http://localhost:18600` to access the Consul UI
 
## Nomad UI
   Open `http://localhost:14646` to access the Nomad UI

## Jaeger UI
   Open `http://localhost:16686` to access the Jaeger UI

## Fake Service UI
   Open `http://localhost:9090/ui` to access the Fake Service UI

## Cleanup
   Run `shipyard destroy` to cleanup all resources
