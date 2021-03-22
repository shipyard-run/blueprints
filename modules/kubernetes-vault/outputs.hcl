output "VAULT_ADDR" {
  value = "http://${docker_ip()}:${var.vault_api_port}"
}

output "VAULT_TOKEN" {
  value = "root"
}