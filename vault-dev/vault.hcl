container "vault" {
  image {
    name = "hashicorp/vault-enterprise:1.4.2_ent"
  }

  command = [
    "vault",
    "server",
    "-dev",
    "-dev-root-token-id=root",
    "-dev-listen-address=0.0.0.0:8200",
  ]

  port {
    local = 8200
    remote = 8200
    host = 8200
    open_in_browser = "/"
  }

  privileged = true

  # Wait for Vault to start
  health_check {
    timeout = "120s"
    http = "http://localhost:8200/v1/sys/health"
  }

  volume {
    source = "./config/vault/files"
    destination = "/files"
  }

  env {
    key = "VAULT_ADDR"
    value = "http://localhost:8200"
  }

  env {
    key = "VAULT_TOKEN"
    value = "root"
  }

  network {
    name = "network.public"
    ip_address = "10.15.0.203"
  }
}

/*
# Run extra setup for the Vault server after start
exec_remote "vault_bootstrap" {
  target = "container.vault"
  cmd = "sh"
  args = ["/files/bootstrap.sh"]
  working_directory = "/files"
}
*/