path "database/creds/db-app" {
  capabilities = ["read"]
}

path "pki/issue/shipyard.run" {
  capabilities = ["update"]
}

path "secret/data/web" {
  capabilities = ["read"]
}