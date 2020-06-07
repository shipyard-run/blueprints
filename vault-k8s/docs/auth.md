---
id: auth
title: Authentication - Configuring Kubernetes Authentication in Vault
sidebar_label: Authentication - Configuring Kubernetes Authentication in Vault
---

To enable applications to authenticate with Vault, we need to enable the Kubernetes authentication backend. This backend allows the application to obtain a Vault token by authenticating with Vault using a Kubernetes Service Account token. The Vault injector automatically manages the process of authentication for you, but you do need to configure Vault for this process to work.

For Vault to verify the Kubernetes Service Account token, the authentication backend needs to know the location of the Kubernetes API and needs to have valid credentials to access the API. You must ensure the Vault cluster uses the correct Kubernetes RBAC rules and service account. The Vault Helm chart and [Vault documentation](https://www.vaultproject.io/docs/auth/kubernetes.html) outlines the proper permissions.

The first step is to enable the Kubernetes authentication backend in Vault.

```shell
vault auth enable kubernetes
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />

Like the database backend, authentication backends also need to be configured, let’s look at the parameters required for this configuration.

The `token_reviewer` parameter is set to a value Kubernetes Service Account token. Vault uses this token to authenticate itself when making calls with the Kubernetes API.

When making a call to the API Vault validates the TLS certificates used by the Kubernetes API. To perform this validation the CA certificate for the Kubernetes server is needed. You set `kubernetes_ca_cert` parameter with the contents of this certificate.

Finally the `kubernetes_host` parameter needs to be set to the address for the Kubernetes API. Vault will use the value of this parameter when making HTTP calls to the API.

If you are running Vault on Kubernetes you can use the following command to set this configuration. The Vault server pod already has a service account token with this information, so we can run a `kubectl exec` to execute the configure command directly in the pod:

```
kubectl exec $(kubectl get pods --selector "app.kubernetes.io/instance=vault,component=server" -o jsonpath="{.items[0].metadata.name}") -c vault -- \
  sh -c ' \
    vault write auth/kubernetes/config \
       token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
       kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
       kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'
```

This configuration is only necessary when setting up a new Kubernetes cluster to work with Vault and only needs to be completed once.

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />

## Policy - Creating policy to allow access to secrets

Policy controls the permissions to access secrets in Vault. In order for our application to create database credentials, you need to define a policy in Vault to allow `read` access to the secret.

Vault applies policy based on the `path` of the secret. For example, the path for database secrets is `database/creds/<role>.` For the role created earlier, you can access the database secret at  `database/creds/db-app`. 

You also need to define capabilities (create, read, update, delete), or access level for the path. Creation of dynamic secrets requires the `read` capability.

```ruby
path "database/creds/db-app" {
  capabilities = ["read"]
}
```

If you have checked out the example code, this policy can be found at `./config/webpolicy.hcl`. You can write the policy to Vault using the `vault policy write <name> <location>` command. Run the following command which will create a policy named `web` from the example file.

```shell
vault policy write web ./web-policy.hcl
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />

### Assigning Vault policy to Kubernetes Service Accounts 

The Vault secret injector uses the Service Account Token allocated to the pod for authentication to Vault. Vault exchanges this for a Vault Token, which has policies assigned. 

![](https://www.datocms-assets.com/2885/1576778470-vault-k8s-auth.png)

To create this mapping, you need to create a `role` in the Kubernetes authentication you configured earlier. This is done by writing configuration to `auth\kubernetes/role/<name>`. To assign the policy `web` when a pod authenticates using the service account `web,` in the namespace `default,` you need to set the following parameters:

* `bound_service_account_names` are the names of the service accounts provided as a comma-separated list that can use this role.

* `bound_service_account_namesapces` are the allowed namespaces for the service accounts.

* `policies` are the policies that you would like to attach to the token.

* `ttl` is the time to live for the Vault token returned from successful authentication.

The full command can be seen in the following snippet. Run this in your terminal to create the role.

```bash
vault write auth/kubernetes/role/web \
    bound_service_account_names=web \
    bound_service_account_namespaces=default \
    policies=web \
    ttl=1h
```

<Terminal target="tools.container.shipyard.run" shell="/bin/bash" workdir="/files" user="root" />