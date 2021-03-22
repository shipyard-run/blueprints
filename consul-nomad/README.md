---
title: "Consul and Nomad"
author: "Anubhav Mishra"
slug: "consul-nomad"
---

This blueprint runs a Consul and Nomad cluster with an example application showing how Consul service mesh metrics
can be sent to Jaeger.

The Application runs the following chain of upstream calls:

```
Ingress 
        | --> API
        | --> Payment 
                      | --> Currency
```

All services run through Consul service mesh and emmit tracing data to the Jaeger instance.