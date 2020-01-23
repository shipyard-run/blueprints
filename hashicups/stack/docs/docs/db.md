---
id: db
title: Secrets - Configuring dynamic secrets for PostgreSQL
sidebar_label: Secrets - Configuring dynamic secrets for PostgreSQL
---

Before you can configure Vault, you need a database. In this example, you will deploy the database to Kubernetes for convenience. You could also use a database from a managed cloud offering or running in a virtual machine or on physical hardware.

Let's deploy the database using the example from the examples repo and create a deployment in your Kubernetes cluster. The example file also creates a service called postgres which points to the pod created by the deployment.

```shell
kubectl apply -f config/postgres.yml
```

<Terminal target="tools.cloud.shipyard" shell="/bin/bash" workdir="/files" user="root" />

While this example focuses on the configuration for PostgreSQL, the workflow for configuration, creating roles, and generating credentials applies to any database.

## Enable the PostgreSQL secrets backend

Before configuring connections and roles, first you need to enable the database backend.

```shell
vault secrets enable database
```

<Terminal target="tools.cloud.shipyard" shell="/bin/bash" workdir="/files" user="root" />

Once the secrets engine has been enabled you can start to create roles.

## Creating database roles

Role configuration controls the tables to which a user has access and the lifecycle of the credentials. Often multiple roles are created for each connection. For example, an application may require read access on the products table but a human operator may require write access to the users table.

You create roles by writing configuration to the path `database/roles/<role name>`. Let's take a look at the parameters in more depth.

The db_name parameter refers to the name of the database connection; we are going to configure the connection for the database in the next step. For now, you can set the value wizard, as this will be the name of the connection when created.

When a user or application requests credentials, Vault will execute the SQL statement defined in the creation_statements parameter. This example, creates a role in the database wizard which allows select access to all tables.

The creation_statements are PostgreSQL standard SQL statements. SQL statements can contain template variables which are dynamically substituted at runtime. If you look at the create SQL statement below, you will see three template variables `{{name}}`, `{{password}}` and `{{expiration}}`:

- {{name}} is the randomly generated username that Vault will generate
- {{password}} is the randomly generated password
- {{expiration}} is the data after which the credentials are no longer valid

```sql
CREATE ROLE '{{name}}' WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; 
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
```

When Vault runs this statement it will replace the template variables with uniquely generated values. For example, the previous statement would become:

```sql
CREATE ROLE 'abc3412vsdfsfd' WITH LOGIN PASSWORD 'sfklasdfj234234fdsfdsd' VALID UNTIL '2019-12-31 23:59:59'; 
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "'abc3412vsdfsfd'";
```

When the TTL for a secret expires Vault runs the SQL statement defined in the revocation_statements parameter. The following statement would disable the PostgreSQL user which is defined by the template variable `{{name}}`.

```sql
ALTER ROLE "{{name}}" NOLOGIN;
```

The final two parameters are `default_ttl` and `max_ttl`.

`default_ttl` defines the lease length for a secret; this is set to 1h; this means you need to renew the lease on a secret every hour.

A lease tells Vault that you are still using the credentials and that it should not automatically revoke them. With the Kubernetes integration for Vault, Vault manages the lease for us. As long as the pod is running, your application can use the secret. However, once the pod terminates, Vault automatically revokes the credentials once the lease expires.

The benefit of lease credentials is that they are automatically revoked after a predetermined period of time, if the credentials leak, the blast radius is dramatically reduced as the period of usefulness for credentials is limited. When a human operator is managing credentials they must manually be revoked, that is assuming the operator is aware of the leak, often they are not until it is too late.

`max_ttl`, specifies the maximum duration which credentials can exist regardless of the number of times a lease is renewed. In this example, max_ttl has a value of 24hrs,after this period, the credentials can not be renewed and Vault automatically revokes them.

The Vault Kubernetes integration automatically renews the credentials. The application handles the renewal process, reading the new credentials, and reloading any database connections. To avoid credentials being revoked while in use, the sidecar process always renews credentials before they expire. This way, the application can safely close any open database connections before rolling over to the new credentials received by the sidecar process.

Let’s put all of this together and write the role to Vault:

```shell
vault write database/roles/db-app \
    db_name=wizard \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    revocation_statements="ALTER ROLE \"{{name}}\" NOLOGIN;"\
    default_ttl="1h" \
    max_ttl="24h"
```

<Terminal target="tools.cloud.shipyard" shell="/bin/bash" workdir="/files" user="root" />

### Creating database connections

A connection manages the root access for a database. For example, your PostgreSQL server has the database `wizard` on it. The connection in Vault is the configuration to connect to and authenticate with that database. Like a role, you configure several parameters.

The `plugin_name` parameter configures which database plugin we would like to use. This example is using a PostgreSQL database so you use `postgresql-database-plugin`

You also need to define which roles can use this connection with the `allowed_roles` parameter; this will be set to the name of the role created in the previous step, `wizard.`

For Vault to connect to the database, you define a standard connection string by setting the `connection_url` parameter. Rather than hardcoding the `username` and `password` in the connection string, you must use template variables to enable Vault's root credential rotation feature. This feature allows Vault to automatically rotate the root credentials for a database.

```
postgresql://{{username}}:{{password}}@postgres:5432/wizard?sslmode=disable"
```

Finally, you define `username` and `password` the initial credentials which Vault will use when connecting to your PostgreSQL database.

You apply this configuration with a `vault write` command. The path this time is going to be `database/config/<connection name>`:

```shell
vault write database/config/wizard \
    plugin_name=postgresql-database-plugin \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@postgres:5432/wizard?sslmode=disable" \
    username="postgres" \
    password="password"
```

<Terminal target="tools.cloud.shipyard" shell="/bin/bash" workdir="/files" user="root" />

### Rotating the root credentials

When you create a new database, you need to create root credentials for configuring additional users. In the example, you use the `POSTGRES_PASSWORD` environment variable your deployment definition to set the database password on initialization.

```yaml
env:
  - name: POSTGRES_PASSWORD
    value: password
```

Since Vault can manage credential creation for both humans and applications, you no longer need the original password. Vaults root rotation can automatically change this password to one only Vault can use.

When Vault rotates root credentials, it connects to the database using its existing root credentials. It then generates a new password for the configured user. Vault saves the password but you cannot retrieve it. This process removes the paper trail associated with the original password. Should you need to access the database then it is always possible to ask Vault to generate credentials. Run the following command to rotate the root credentials:

```shell
vault write --force /database/rotate-root/wizard
```

After running this command, you can check that Vault has rotated the credentials by trying to login using `psql` using the original credentials:

```shell
kubectl exec -it \
  $(kubectl get pods --selector "app=postgres" -o jsonpath="{.items[0].metadata.name}") \
  -c postgres -- \
  bash -c 'PGPASSWORD=password psql -U postgres'
```

Finally you can test the generation of credentials for your application by using the `vault read database/creds/<role>` command. 

```shell
vault read database/creds/db-app
```

If you look at the output from this command, you see a randomly generated `username` and `password`and a `lease` equal to the `default_ttl` you configured when creating the role.

<Terminal target="tools.cloud.shipyard" shell="/bin/bash" workdir="/files" user="root" />