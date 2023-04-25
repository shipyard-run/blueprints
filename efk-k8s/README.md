---
title: "EFK stack and Kubernetes"
author: "Gilad Neiger | develeap"
slug: "efk_k8s"
---

This blueprint creates a Kubernetes cluster with EFK stack installed
(The installed efk stack by develeap: `https://github.com/develeap/efk-stack`)

## Kibana UI
To access the Kibana UI point your browser at:

`http://localhost:5601`

The user `elastic` can be used to authenticate
  
## Cleanup

Run `shipyard destroy` to cleanup all resources

## Components
* Kubernetes
* EFK stack (`https://github.com/develeap/efk-stack`)
