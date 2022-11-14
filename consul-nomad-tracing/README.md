---
title: "Consul and Nomad"
author: "Anubhav Mishra"
slug: "consul-nomad"
health_check_timeout: 100s
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

The Api service that is accessible at the url `http://localhost:19090` and all the other servies in the application
create a span for the individual units of work. These spans are sent to Jaeger `http://localhost:16686`, where they can be visualised as a
trace timeline.

All services run through Consul service mesh the proxies of which also emmit spans data to the Jaeger instance. The result is a full
profile consisting of durations for individual service calls and their individual components. 

## Application Endpoints:
* Consul:   http://localhost:18500
* Jaeger:   http://localhost:16686
* Ingress:  http://localhost:19090

## Accessing Nomad
The Nomad cluster is not exposed on port `4646` but a random port, to use the Nomad
cli to interact with the cluster you need to set the environment variable `NOMAD_ADDR`.
This address can be found in the Shipyard output variables. 
