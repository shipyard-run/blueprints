output "CONSUL_HTTP_ADDR" {
  value = "${docker_ip()}:${var.consul_api_port}"
}
