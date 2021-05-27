# consul tls cert create -server -node dc2.server.shipyard.run -ca /home/nicj/.shipyard/data/helm/tls.crt -key /home/nicj/.shipyard/data/helm/tls.key
#
# consul agent -bind '{{ GetInterfaceIP "eth0" }}' -config-file ./consul_config.hcl
node_name = "server"
data_dir = "/tmp"

datacenter = "dc2"
primary_datacenter = "dc1"

server = true
bootstrap_expect = 1
log_level = "DEBUG"
ui = true

auto_encrypt {
  allow_tls = true
}

verify_incoming_rpc = true
verify_outgoing = true
verify_server_hostname = true

primary_gateways = ["10.5.0.200:30443"]
connect {
  enabled = true
  enable_mesh_gateway_wan_federation = true
}

addresses {
  https = "0.0.0.0"
  http = "0.0.0.0"
  grpc = "0.0.0.0"
}

ports {
  grpc = 8502
}

key_file = "/files/dc2-server-consul-0-key.pem"
cert_file = "/files/dc2-server-consul-0.pem"
ca_file = "/files/tls.crt"