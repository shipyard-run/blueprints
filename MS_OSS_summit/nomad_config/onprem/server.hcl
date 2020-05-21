data_dir = "/etc/nomad.d/data"
// bind_addr = "0.0.0.0"
datacenter = "onprem"
region = "onprem"

addresses {
  http = "0.0.0.0"
  rpc = "0.0.0.0"
  serf = "0.0.0.0"
}

advertise {
  serf = "192.168.5.100"
}

server {
  enabled = true
  bootstrap_expect = 1
}

client {
    enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}