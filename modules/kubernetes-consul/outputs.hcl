output "CONSUL_HTTP_ADDR" {
  value = "${var.consul_tls_enabled ? "https://" : "http://"}${docker_ip()}:${var.consul_ports_api}"
}

output "CONSUL_TOKEN_FILE" {
  value = "${var.consul_acls_enabled ? "${data("helm")}/bootstrap_acl.token" : ""}"
}

output "CONSUL_CAPATH" {
  disabled = (var.consul_tls_enabled == false)

  value = "${data("helm")}/tls.crt"
}

output "CONSUL_CAKEY" {
  value = "${var.consul_tls_enabled ? "${data("helm")}/tls.key" : ""}"
}
