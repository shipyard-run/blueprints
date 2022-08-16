data_dir               = "/tmp"
verify_incoming        = false
verify_outgoing        = true
verify_server_hostname = true
ca_file                = "/certs/ca.cert"
datacenter             = "vms"

auto_encrypt = {
  tls = true
}

retry_join = ["1-consul-server.container.shipyard.run"]
