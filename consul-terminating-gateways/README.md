---
title: "Consul Terminating Gateway with Nomad"
author: "Nicole Hubbard"
slug: "consul-nomad"
env:
  - NOMAD_ADDR="http://localhost:14646"
  - CONSUL_HTTP_ADDR="http://localhost:18600"
---

This blueprint comprises of Mysql, Consul, Consul Terminating Gateway, and Nomad.

## Set the following environment variables to interact with this blueprint

```
export NOMAD_ADDR="http://localhost:14646"
export CONSUL_HTTP_ADDR="http://localhost:18600"
 ```

## Cleanup
   Run `shipyard destroy` to cleanup all resources
