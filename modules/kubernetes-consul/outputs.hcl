output "CONSUL_HTTP_ADDR" {
  value = "${var.consul_tls_enabled ? "https://" : "http://"}${docker_ip()}:${var.consul_ports_api == 0 ? (var.consul_tls_enabled == "true" ? 8501 : 8500) : var.consul_ports_api}"
}

output "CONSUL_TOKEN_FILE" {
  disabled = (var.consul_acls_enabled == false)

  value = "${var.consul_data_folder}/bootstrap_acl.token"
}

output "CONSUL_CAPATH" {
  disabled = (var.consul_tls_enabled == false)

  value = "${var.consul_data_folder}/tls.crt"
}

output "CONSUL_CAKEY" {
  value = "${var.consul_tls_enabled ? "var.consul_data_folder/tls.key" : ""}"
}