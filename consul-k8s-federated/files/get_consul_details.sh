#!/bin/bash

# Export ACL Token for accessing Consul locally
kubectl get secret consul-acl-replication-acl-token -o jsonpath="{.data.token}" | base64 -d > /files/acl_token.txt

# Export the Consul CA for accessing Consul locally
kubectl get secret consul-ca-cert -o jsonpath="{.data.*}" | base64 -d > /files/ca.pem

# Export the Federation secret from DC1 and import into DC2
KUBECONFIG="/config_dc1.yaml" kubectl get secret consul-federation -o yaml > /tmp/federation_secret.yaml

# Import the secret to the DC2 server
KUBECONFIG="/config_dc2.yaml" kubectl apply -f /tmp/federation_secret.yaml