---
id: index
title: New Terraform Kubernetes Provider
sidebar_label: Introduction
---

This example shows how to use the Alpha Terraform Kubernetes Provider to provision Kubernetes resources with Terraform.

[https://github.com/hashicorp/terraform-provider-kubernetes-alpha](https://github.com/hashicorp/terraform-provider-kubernetes-alpha)

## New Provider

The new provider allows arbitary resources to be applied to Kubernetes using Terraform. While the existing provider uses structured resources such as `kubernetes_deployment`, with the new provider
you can simply convert K8s YAML into Terraform resources as shown in the below example.  This approach allows you to manage the lifecycle of the resources with Terraform and also allows you to leverage
interpolation for dependency based application of resources. The full file can be found in the `./files/k8s_deployment.tf`.

```javascript
variable "replicas" {
  default = 3
}

resource "kubernetes_manifest" "nginx" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "nginx"
      }
      "name"      = "nginx-deployment"
      "namespace" = "default"
    }
    "spec" = {
      "replicas" = var.replicas
      "selector" = {
        "matchLabels" = {
          "app" = "nginx"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "nginx"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "nginx:1.14.2"
              "name"  = "nginx"
              "ports" = [
                {
                  "containerPort" = 80
                  "protocol"      = "TCP"
                },
              ]
            },
          ]
        }
      }
    }
  }

}
```

## Intialize Terraform

The experimental provider plugin has already been downloaded and installed to `/root/.terraform.d/plugins`, the first step is to initialize the Terraform config.

```
terraform init
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" expanded />
</p>

## Apply the configuration

You can then apply the configuration. The apply command will show you an output of the changes which will be made to the cluster. You can type `yes` to proceed
and to apply the config.

```
terraform apply
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" expanded />
</p>

## Checking resources have been created

To check the resources have been created you can use `kubectl get pods`, you will see 3 insances of Nginx.

```
kubectl get pods
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
</p>

## Changing state
By default the Terraform configuration will create 3 instances, this is defined by the variable `replicas`, you can apply the Terraform configuration again overriding this value.

**NOTE:** This step currently crashes due to to Terraform state errors. This will be fixed in a later release.

```
terraform apply -var replicas=1
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
</p>

## Checking resources have been reduced

To check the resources have been created you can use `kubectl get pods`, you will now see only 1 instance of the pod.

```
kubectl get pods
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
</p>

## Destroying resources

To remove resources in Kuberentes which were created with Terraform you can use the following command. Terraform will show you exactly what will be destroyed
and ask for confirmation.

```
terraform destroy
```

<p>
  <Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />
</p>

After destroying you can use `kubectl get pods` to check that the resrources have been deleted