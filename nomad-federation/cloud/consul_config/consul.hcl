data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "cloud"
primary_datacenter = "onprem"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

advertise_addr = "10.10.0.100"
advertise_addr_wan = "192.168.10.100"

retry_join_wan = ["192.168.5.100"]

ports {
  grpc = 8502
}

connect {
  enabled = true
}

telemetry {
    prometheus_retention_time = "30s"
}

enable_central_service_config = true

config_entries {
  # We are using gateways and L7 config set the 
  # default protocol to HTTP
  bootstrap 
    {
      kind = "proxy-defaults"
      name = "global"

      config {
        protocol = "http"
      }

      mesh_gateway = {
        mode = "local"
      }
    }
}