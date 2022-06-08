---
title: "HashiCorp Waypoint and Kubernetes"
author: "Nic Jackson"
slug: "waypoint_k8s"
---

## Waypoint config
To build and push to the local registry add the following to your waypoint config

```javascript
   registry {
      use "docker" {
        image = "10.10.0.10/hashicraft/payments"
        tag   = "latest"
      }
    }
```

## Waypoint auth token

To get the auth token run the foloo

```
echo $(k get secret waypoint-server-token -o json | jq -r '.data.token') | base64 -d
```