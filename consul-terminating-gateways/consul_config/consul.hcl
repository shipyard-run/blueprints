data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "dc1"

server = true

bootstrap_expect = 1
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

ports {
  grpc = 8502
}

connect {
  enabled = true
}

config_entries {
  bootstrap = [
    {
      kind = "terminating-gateway"
      name = "mysql-gateway"
      services = [
        {
          name = "mysql"
        }
      ]
    }
  ]
}