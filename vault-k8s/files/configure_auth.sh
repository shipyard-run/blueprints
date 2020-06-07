#!/bin/sh

vault auth enable kubernetes

kubectl exec $(kubectl get pods --selector "app.kubernetes.io/instance=vault,component=server" -o jsonpath="{.items[0].metadata.name}") -c vault -- \
  sh -c ' \
    vault write auth/kubernetes/config \
       token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
       kubernetes_host=https://${KUBERNETES_PORT_443_TCP_ADDR}:443 \
       kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

vault write auth/kubernetes/role/web \
    bound_service_account_names=web \
    bound_service_account_namespaces=default \
    policies=web \
    ttl=1h