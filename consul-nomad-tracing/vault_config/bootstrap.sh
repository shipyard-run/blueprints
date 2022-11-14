#!/bin/sh -e

vault status

vault policy write nomad-server nomad-server-policy.hcl
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json

VAULT_NOMAD_TOKEN=$(vault token create -policy nomad-server -orphan -period 100h | grep 'token ' | awk '{print $2;}')
echo -n "$VAULT_NOMAD_TOKEN" > /data/vault_nomad_token.txt

# for example only - create an example secret
vault kv put secret/hello foo=world
