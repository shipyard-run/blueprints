#!/bin/bash -e
export VAULT_TOKEN=root
export KUBECONFIG="$HOME/.shipyard/config/k3s/kubeconfig-docker.yaml"

echo "Configuring Vault"

# This should not be necessary
sleep 10

# Enable and configure Kubernetes Authentication
vault auth enable kubernetes

kubectl exec $(kubectl get pods --selector "app.kubernetes.io/instance=vault,component=server" -o jsonpath="{.items[0].metadata.name}") -c vault -- \
  sh -c ' \
    vault write auth/kubernetes/config \
       token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
       kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
       kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

# Enable and configure PostgresSQL Dynamic secrets
vault secrets enable database

vault write database/config/products \
    plugin_name=postgresql-database-plugin \
    verify_connection=false \
    allowed_roles="*" \
    connection_url="postgresql://{{username}}:{{password}}@postgres:5432/products?sslmode=disable" \
    username="postgres" \
    password="password"

# Rotate the database root password
#vault write --force database/rotate-root/wizard

# Create a role allowing credentials to be created with access for all tables in the DB
vault write database/roles/db-products \
    db_name=products \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
        GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
    revocation_statements="ALTER ROLE \"{{name}}\" NOLOGIN;"\
    default_ttl="1h" \
    max_ttl="24h"

# Write the policy to allow read access to the role
# we are using dirname "$0" to get the current directory for this script
# we cannot use relative paths as they may not work
vault policy write products-api $(dirname "$0")/products_policy.hcl

# Assign the policy to users who authenticate with Kubernetes service accounts called web
vault write auth/kubernetes/role/products-api \
    bound_service_account_names=products-api \
    bound_service_account_namespaces=default \
    policies=products-api \
    ttl=1h