data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc2"
primary_datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

# When the os has multiple NICs we need to tell
# Consul which to use for local advertise
advertise_addr = "10.16.0.201"

# When the os has multiple NICs we need to tell
# Consul which to use for WAN advertise
advertise_addr_wan = "192.168.0.201"

# DC1 servers WAN address to join cluster
retry_join_wan = ["192.168.0.200"]

ports {
  grpc = 8502
}

connect {
  enabled = true
}