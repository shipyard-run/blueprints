output "KIBANA_ADDR" {
  value = "http://${docker_ip()}:${var.kibana_port}"
}