---
id: index
title: Dynamic Database Credentials with Vault and Kubernetes
sidebar_label: Introduction
---

Providing database credentials for your Kubernetes applications has always proved operationally challenging. For optimum security, we ideally need to implement the following requirements for database credentials:

* Each Kubernetes pod should have a unique set of credentials
* Credentials should be disabled or deleted when a pod terminates
* Credentials should be short-lived and rotated frequently
* Access should be restricted by application function, a system which only needs to read a specific table, should have database access which grants this particular purpose

While these requirements are essential for reducing the blast radius in the event of an attack, they are operationally challenging. The reality is that without automation, it is impossible to satisfy them. HashiCorp Vault solves this problem by enabling operators to provide dynamically generated credentials for applications. Vault manages the lifecycle of credentials, rotating and revoking as required.

In this blog post, we will look at how the Vault integration for Kubernetes allows an operator or developer to use metadata annotations to inject dynamically generated database secrets into a Kubernetes pod. The integration automatically handles all the authentication with Vault and the management of the secrets, the application just reads the secrets from the filesystem.

## Summary of Integration Workflow

When a new deployment is submitted to Kubernetes, a mutating webhook modifies the deployment, injects a Vault sidecar. This sidecar manages the authentication to Vault and the retrieval of secrets. The retrieved secrets are written to a pod volume mount that your application can read.

For example, we can use Vault to dynamically generate database credentials for a PostgreSQL database. Adding the annotations shown in the following example automatically inject secrets controlled by the db-creds role into the pod.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    app: web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/agent-inject-secret-db-creds: "database/creds/db-app"
```

https://www.vaultproject.io/docs/platform/k8s/injector/index.html

By convention Vault will inject these at the path `/vault/secrets/<secret name>`, the following snippet shows an example of this file.

```shell
username: v-kubernet-db-app-QDTv8wn6oGze6aGxuYbQ-1576778182
password: A1a-7kHXqX0jdh8ys74H
```

Before we will walk through the process of deploying and configuring Vault in a Kubernetes cluster and learn how to inject PostgreSQL credentials into a Kubernetes deployment. Let's introduce some HashiCorp Vault’s core concepts.

## Introduction to Vault

Vault is built around three main concepts:

* Secrets
* Authentication
* Policy

In this section, we review how these concepts work in Vault.

![](https://www.datocms-assets.com/2885/1576778376-vault-workflow-illustration-policy.png)

### Secrets

You can have static secrets like an API key or a credit card number or dynamic secrets like auto-generated cloud or database credentials. Vault generates dynamic secrets on-demand, while you receive static secrets already pre-defined.

With static secrets, you must create and manage the lifecycle of the secret. For example, you could store an email account password in Vault but you need to ensure that it is periodically changed.

With dynamic secrets, you delegate the responsibility to Vault for creating and managing the lifecycle of a secret. For example, you give Vault the root credentials for your PostgreSQL database, granting it access to create credentials on your behalf. When you want to log into the database, you ask Vault for credentials. Vault makes a connection to the database and generates a set of restricted access credentials. These are not permanent but leased. Vault manages the lifecycle, automatically rotating the password and revoking the access when they are no longer required.

One of the critical features of defense in depth is rotating credentials. In the event of a breach, credentials with a strict time to live (TTL) can dramatically reduce the blast radius.

![](https://www.datocms-assets.com/2885/1576778435-vault-db.png)

### Authentication

To access secrets in Vault, you need to be authenticated; authentication is in the form of pluggable backends. For example, you can use a Kubernetes Service Account token to authenticate to Vault. For human access, you could use something like GitHub tokens. In both of these instances, Vault does not directly store the credentials; instead, it uses a trusted third party to validate the credentials.  With Kubernetes Service Account tokens, when an application attempts to authenticate with Vault, Vault makes a call to the Kubernetes API to ensure the validity of the token. If the token is valid, it returns an internally managed Vault Token, used by the application for future requests.

![](https://www.datocms-assets.com/2885/1576778470-vault-k8s-auth.png)

### Policy

Policy ties together secrets and authentication by defining which secrets and what administrative operations an authenticated user can perform. For example, an operator may have a policy which allows them to configure secrets for a PostgreSQL database, but not generate credentials. An application may have permission to create credentials but not configure the backend. Vault policy allows you correctly separate responsibility based on role.

```ruby
# policy allowing creation and configuration of databases and roles
path “database/roles/*” {
  capabilities = [“create”, “read”, “update”, “delete”, “list”] 
}

path “database/config/*” {
  capabilities = [“create”, “read”, “update”, “delete”, “list”] 
}

# policy allowing credentials for the wizard database to be created 
path “database/creds/wizard” {
  capabilities = [“read”] 
}
```