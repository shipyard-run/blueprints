data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "k8s"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

retry_join_wan = ["consul-k8s-http.cloud.shipyard"]

ports {
  grpc = 8502
}

connect {
  enabled = true
}