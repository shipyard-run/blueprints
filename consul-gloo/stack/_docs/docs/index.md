---
id: index
title: Kubernetes Gateways with Gloo and Consul
sidebar_label: Example Page
---

## Expose services through a Kubernetes API Gateway

We use an edge gateway/ingress called [Gloo which is an open-source API Gateway](https://docs.solo.io/gloo/latest/) built on [Envoy Proxy](https://docs.solo.io/gloo/latest/) to handle routing into the cluster. Gloo also enables some other features like debugging which we'll dive into later in the tutorial. To get started with Gloo, let's install the proxy and its control plane into the `gloo-system` namespace.

We should see various CRDs, services and deployments installed into the cluster. Once finished, we should be able to get the kubernetes pods from the `gloo-system` namespace to verify all of the components have come up. The important components are the `gateway-proxy-v2` and `gloo` components.

### Getting the Gloo Pods

```shell
kubectl get po -n gloo-system
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

Gloo routes to an abstraction called an `upstream` which can be a Kubernetes service, or a service defined in Consul, or even a cloud function like an AWS Lambda. Gloo has a function discovery component (cleverly called `discovery`) in the control plane that will automatically discover these services or functions. Let's list the `upstreams` Gloo discovered and verify that our `web` service is there.

### Check for the web upstream

```shell
glooctl get upstream | grep web
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

Gloo exposes APIs and services through the proxy using an API called the `VirtualService` resource. Let's create a `default` `VirtualService` and add a route to Gloo's routing table which takes traffic from the edge of the cluster and routes to the `web` service.

### Create a default VirtualService

```shell
glooctl create vs default
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

### Create a route in Gloo to the web service

```shell
glooctl add route --path-prefix / --dest-name default-web-9090
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

From within the VSCode terminal, we should be able to call the service through the Gloo API Gateway.

### Calling the API Gateway

```shell
curl -v http://gloo.ingress.shipyard
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />