output "CONSUL_HTTP_ADDR" {
  disabled = !var.consul_set_outputs

  value = "${var.consul_tls_enabled ? "https://" : "http://"}${docker_ip()}:${var.consul_ports_api == 0 ? (var.consul_tls_enabled ? 8501 : 8500) : var.consul_ports_api}"
}

output "CONSUL_HTTP_TOKEN_FILE" {
  disabled = (var.consul_acls_enabled == false || var.consul_set_outputs == false)

  value = "${var.consul_data_folder}/bootstrap_acl.token"
}

output "CONSUL_CACERT" {
  disabled = (var.consul_tls_enabled == false || var.consul_set_outputs == false)

  value = "${var.consul_data_folder}/tls.crt"
}

output "CONSUL_CAKEY" {
  disabled = (var.consul_tls_enabled == false || var.consul_set_outputs == false)

  value = "${var.consul_data_folder}/tls.key"
}
