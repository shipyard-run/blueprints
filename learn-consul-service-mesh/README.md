# Learn Consul Service Mesh

This blueprint helps you deploy Consul Connect service mesh in a Kubernetes (k8s) cluster.

## Prerequisites

- [Docker](https://docs.docker.com/) installed in your test machine.
- [helm](https://helm.sh/docs/using_helm/) to deploy your Consul Connect instance
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) to interact with your Kubernetes cluster and deploy services
- [Consul binary](https://learn.hashicorp.com/consul/getting-started/install) to interact with the Consul Connect-enabled datacenter you are deploying.

## Run the blueprint

1. [Install Shipyard](https://shipyard.run/docs/install/)
1. Clone the blueprints repository.
```shell
git clone https://github.com/shipyard-run/blueprints.git
cd blueprints
```
1. Run the blueprint.
```shell
shipyard run ./learn-consul-service-mesh/blueprint
```

In the default configuration the blueprint will deploy a k8s cluster and a k8s dashboard. The ingress to access the dashboard will be automatically created on port `18443`. Once deploy is completed you will be able to access the dashboard at `http://localhost:18443`.

**Security Note:** The dashboard is deployed with authentication disabled to speed up testing.

## Deploy Consul Connect service mesh with Helm

```shell
cd ./blueprints/learn-consul-service-mesh
helm install hashicorp ./helm-charts/consul-helm-0.16.2 -f ./helm-charts/consul-values.yml
```

Setup ingress for Consul UI:

```shell
shipyard run ./blueprint/ingresses/consul-ui.hcl
```

## Files and configuration

The blueprint is composed by a `.yard` file that will provide some information on the scenario once executed.

- `main.yard` - blueprint definition file
- `network.hcl` - defines the networks to be created for the k8s cluster.
- `k8s.hcl` -  Kubernetes configuration, it defines the k8s cluster and can be used to automaticaly deploy services.
- `ingress.hcl` - Defines ingresses for the k8s cluster. Used to enable external access to k8s services.
- `helm.hcl` - Contains Helm configuration to deploy charts inside the k8s cluster automatically.


The naming convention is used to help you logically separate configuration. 
Shipyard will try to run every `.hcl` file in the folder so you can add custom configuration under any file or create new files if needed.

You can comment out sections in the `.hcl` files in case you don't want to deploy parts of your configuration.
The files in the blueprint come with many commented sections to help you automate the configuration once you got familiar with the deploy process.

## Folders and configuration

- `k8s_config` - Contains k8s configuration files. Files in this folder can either be deployed automatically by adding (or uncommenting) sections in the `k8s.hcl` file or manually using `kubectl apply`. The blueprint provides some examples to help you familiarize with the syntax.
- `ingresses` - Contains ingress configurations for services to be deployed in the k8s cluster. You can apply the configs in this flder using `shipyard run`. The blueprint provides some examples to help you familiarize with the syntax.
- `helm-charts` - Contains helm charts to be deployed into the k8s cluster. Files in this folder can either be deployed automatically by adding (or uncommenting) sections in the `helm.hcl` file or manually using `helm install`. The blueprint provides the official [HashiCorp Consul Helm chart](https://github.com/hashicorp/consul-helm) for installing and configuring Consul on Kubernetes. A basic example configuration for the chart is also provided at `./helm-charts/consul-values.yml`.