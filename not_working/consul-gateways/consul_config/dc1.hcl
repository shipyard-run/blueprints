data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

# When the os has multiple NICs we need to tell
# Consul which to use for local advertise
advertise_addr = "10.15.0.200"

# When the os has multiple NICs we need to tell
# Consul which to use for WAN advertise
advertise_addr_wan = "192.168.0.200"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

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

    # The API service is only available in DC2
    # create a service resolver which explicitly sets the
    # datacenter
    bootstrap {
      kind = "service-resolver"
      name = "api"

      redirect {
        service    = "api"
        datacenter = "dc2"
      }
    }
}