
container "vault" {
  image {
    name = "hashicorp/vault:${var.vault_version}"
  }

  command = [
    "vault",
    "server",
    "-dev",
    "-dev-root-token-id=${var.vault_root_token}",
    "-dev-listen-address=0.0.0.0:8200",
    "-dev-plugin-dir=/plugins"
  ]

  port {
    local           = 8200
    remote          = 8200
    host            = 8200
    open_in_browser = ""
  }

  privileged = true

  # Wait for Vault to start
  health_check {
    timeout = "120s"
    http    = "http://localhost:8200/v1/sys/health"
  }

  env {
    key   = "VAULT_ADDR"
    value = "http://localhost:8200"
  }

  env {
    key   = "VAULT_TOKEN"
    value = var.vault_root_token
  }

  network {
    name       = "network.${var.vault_network}"
    ip_address = var.vault_ip_address
  }

  volume {
    source      = var.vault_data
    destination = "/data"
  }

  volume {
    source      = var.vault_plugin_folder
    destination = "/plugins"
  }
}

template "vault_bootstrap" {
  source = var.vault_bootstrap_script

  destination = "${var.vault_data}/bootstrap.sh"
}

exec_remote "vault_bootstrap" {
  target            = "container.vault"
  cmd               = "sh"
  args              = ["/data/bootstrap.sh"]
  working_directory = "/data"
}

output "VAULT_ADDR" {
  value = "http://localhost:8200"
}

output "VAULT_TOKEN" {
  value = var.vault_root_token
}
