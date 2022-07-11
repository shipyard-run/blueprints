output "CONSUL_HTTP_ADDR" {
  value = var.cd_consul_tls_enabled ? "https://1.consul.server.container.shipyard.run:8501" : "http://1.consul.server.container.shipyard.run:8500"
}

output "CONSUL_CACERT" {
  disabled = !var.cd_consul_tls_enabled

  value = "${var.cd_consul_data}/cd_consul_ca.cert"
}

output "CONSUL_HTTP_SSL_VERIFY" {
  disabled = !var.cd_consul_tls_enabled

  value ="false"
}

output "CONSUL_HTTP_TOKEN" {
  disabled = !var.cd_consul_acls_enabled

  value = "$(cat ${var.cd_consul_data}/bootstrap.token)"
}
