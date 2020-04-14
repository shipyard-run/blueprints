data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

retry_join = ["consul.container.shipyard.run"]

ports {
  grpc = 8502
}

connect {
  enabled = true
}

enable_central_service_config = true