output "CONSUL_HTTP_ADDR" {
  value = "${var.consul_enable_tls ? "https://" : "http://"}${docker_ip()}:${var.consul_api_port}"
}

output "CONSUL_TOKEN_FILE" {
  value = "${var.consul_enable_acls ? "${data("helm")}/bootstrap_acl.token" : ""}"
}

output "CONSUL_CA_CERT_FILE" {
  value = "${var.consul_enable_tls ? "${data("helm")}/tls.crt" : ""}"
}

output "CONSUL_CA_KEY_FILE" {
  value = "${var.consul_enable_tls ? "${data("helm")}/tls.key" : ""}"
}

