---
id: secrets
title: Injecting secrets into Kubernetes Deployments
sidebar_label: Injecting secrets into Kubernetes Deployments
---

Now the Vault configuration is complete, you can inject the secrets into the application.

First, you need to match the name of a Kubernetes Service Account to the name of the role you configured in the previous step.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: web
automountServiceAccountToken: true
```

You can then configure the deployment to inject the database credentials automatically with an annotation. The first annotation you need to add tells Vault to inject a sidecar to manage secrets into the deployment automatically.

`vault.hashicorp.com/agent-inject: "true"`

You can then tell it which secrets you would like to inject, such as the database credentials which were configured earlier.

`vault.hashicorp.com/agent-inject-secret-db-creds: "database/creds/db-app"`

The injector mounts the secrets in the pod  at `/vault/secrets/<name>`. For database credentials, the default format would be:

```
username: random-user-name
password: random-password
```

To control the format so that the application can read it in a native format, you can use the annotation `vault.hashicorp.com/agent-inject-template-[filename],` to define a custom template. This template uses Consul Template format: [https://github.com/hashicorp/consul-template#secret](https://github.com/hashicorp/consul-template#secret). 

The following annotation example would allow us to use this templating feature to generate a JSON formatted config file which contains a connection string suitable for Go's standard SQL package. 

```yaml
vault.hashicorp.com/agent-inject-template-db-creds: |
{
{{- with secret "database/creds/db-app" -}}
  "db_connection": "host=postgres port=5432 user={{ .Data.username }} password={{ .Data.password }} dbname=wizard sslmode=disable"
{{- end }}
}
```

Let's step through this line by line.

After the annotation name and pipe, which allows us to define a multi-line string as a value in YAML, we have standard JSON, which denotes the start of an object `{. `.

If you look at the following line, you will see `{{- with secret "database/creds/db-app" -}}`. In the templating language, this reads a secret from `database/creds/db-app` and to then make the data from that operation available to anything inside the block.

Then we have the actual connection string itself; we are creating an attribute on our JSON object called `db_connection,` the contents of this is a standard Go SQL connection for PostgreSQL. The exception to this `{{ .Data.username }}` and `{{ .Data.password }}`. Anything encapsulated by `{{ }}` is a template function or variable. We retrieve the values of the username and password from the secret and write them to the config.

`"db_connection": "host=postgres port=5432 user={{ .Data.username }} password={{ .Data.password }} dbname=wizard sslmode=disable"`

Finally, we close the secret block with `{{- end }}.`

Once this has been processed the output will look something like:

```json
{
  "db_connection": "host=postgres port=5432 user=abcsdsde23sddf password=2323kjc898dfs dbname=wizard sslmode=disable"
}
```

The final part of the annotations is to specify the role which will be used by the sidecar authentication; this is the role you created earlier when configuring Vault.

`vault.hashicorp.com/role: "web"`

Putting all of this together you get a deployment which looks something like the following example:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    app: web
spec:
  replicas: 2
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
        vault.hashicorp.com/agent-inject-template-db-creds: |
          {
          {{- with secret "database/creds/db-app" -}}
          "db_connection": "postgresql://{{ .Data.username }}:{{ .Data.password }}@postgres:5432/wizard"
          {{- end }}
          }
        vault.hashicorp.com/role: "web"
    spec:
      serviceAccountName: web
      containers:
        - name: web
          image: nicholasjackson/fake-service:v0.7.3
```

This can then be deployed in the usual Kubernetes way.

```bash
kubectl apply -f ./config/web.yml
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

The injector automatically modifies your deployment, adding a `vault-agent` container which has been configured to authenticate with the Vault, and to write the secrets into a shared volume.

You can see this in action by running the following command; you will see the secrets which have been written as a JSON file. Whenever the secrets expire, Vault will automatically regenerate this file; your application can watch for changes reloading the configuration as necessary.

```
kubectl exec -it \
  $(kubectl get pods --selector "app=web" -o jsonpath="{.items[0].metadata.name}") \
  -c web cat /vault/secrets/db-creds
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />

Since the deployment contains two pods, you can also run the following command to look at the second pod; you will see that each pod has been allocated unique database credentials.

```
kubectl exec -it \
$(kubectl get pods --selector "app=web" -o jsonpath="{.items[1].metadata.name}") \
-c web cat /vault/secrets/db-creds
```

<Terminal target="tools.container.shipyard" shell="/bin/bash" workdir="/files" user="root" />