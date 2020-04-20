data_dir = "/etc/nomad.d/data"
// bind_addr = "0.0.0.0"
datacenter = "cloud"
region = "cloud"

addresses {
  http = "0.0.0.0"
  rpc = "0.0.0.0"
  serf = "0.0.0.0"
}

advertise {
  serf = "192.168.10.100"
}

server {
  enabled = true
  bootstrap_expect = 1
}

server_join {
    retry_join = ["192.168.5.100:4648"]
}

client {
    enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}