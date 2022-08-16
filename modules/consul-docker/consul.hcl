certificate_ca "cd_consul_ca" {
  disabled = !var.cd_consul_tls_enabled

  output = data("certs")
}

certificate_leaf "cd_consul_server" {
  disabled   = !var.cd_consul_tls_enabled
  depends_on = ["certificate_ca.cd_consul_ca"]

  ca_key  = "${data("certs")}/cd_consul_ca.key"
  ca_cert = "${data("certs")}/cd_consul_ca.cert"

  ip_addresses = ["127.0.0.1"]

  dns_names = [
    "localhost",
    "server.${var.cd_consul_dc}.consul",
    "1-consul-server.container.shipyard.run",
    "2-consul-server.container.shipyard.run",
    "3-consul-server.container.shipyard.run",
    "1-consul-server.server.${var.cd_consul_dc}.consul",
    "2-consul-server.server.${var.cd_consul_dc}.consul",
    "3-consul-server.server.${var.cd_consul_dc}.consul",
  ]

  output = data("certs")
}

copy "cd_consul_certs" {
  depends_on = ["certificate_leaf.cd_consul_server"]

  source      = data("certs")
  destination = var.cd_consul_data
  permissions = "0444"
}

template "cd_consul_config" {
  source = <<-EOF
data_dir = "/tmp/"
log_level = "DEBUG"

datacenter = "#{{ .Vars.datacenter }}"
primary_datacenter = "#{{ .Vars.primary_datacenter }}"

server = true

bootstrap_expect = #{{ .Vars.server_instances }}
ui = true

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "{{GetInterfaceIP \"eth1\"}}"

retry_join = ["1-consul-server.container.shipyard.run", "2-consul-server.container.shipyard.run", "3-consul-server.container.shipyard.run"]

ports {
  grpc = 8502
  https = 8501
}

connect {
  enabled = true
  #{{ if eq .Vars.gateway_enabled true }}
  enable_mesh_gateway_wan_federation = true
  #{{ end }}
}

acl {
  enabled = #{{ .Vars.acls_enabled }}
  default_policy = "deny"
  enable_token_persistence = true
  enable_token_replication = true
}

#{{ if eq .Vars.tls_enabled true }}
tls {
  defaults {
    ca_file = "/config/cd_consul_ca.cert"
    cert_file = "/config/cd_consul_server.cert"
    key_file = "/config/cd_consul_server.key"
    verify_incoming = false
    verify_outgoing = true
  }
}

auto_encrypt {
  allow_tls = true
}
#{{ end }}

EOF

  vars = {
    acls_enabled       = var.cd_consul_acls_enabled
    tls_enabled        = var.cd_consul_tls_enabled
    datacenter         = var.cd_consul_dc
    primary_datacenter = var.cd_consul_primary_dc
    server_instances   = var.cd_consul_server_instances
    gateway_enabled    = var.cd_gateway_enabled
  }

  destination = "${var.cd_consul_data}/server_config.hcl"
}

template "cd_consul_bootstrap" {
  source = <<-EOF
  #!/bin/sh

  # Wait until Consul can be contacted
  until curl -s localhost:8500/v1/status/leader | grep 8300; do
    echo "Waiting for Consul to start"
    sleep 1
  done

  # Bootstrap Consul?
  #{{ if eq .Vars.acls_enabled true }}
  consul acl bootstrap -format json | jq -r '.SecretID' > /config/bootstrap.token

  export CONSUL_HTTP_TOKEN=$(cat /config/bootstrap.token)

  # create the agent token policy
  cat <<-EOT > /config/agent-policy.hcl
  node_prefix "" {
     policy = "write"
  }
  service_prefix "" {
     policy = "read"
  }
  EOT
  
  consul acl policy create -name "agent-token" -description "Agent Token Policy" -rules @/config/agent-policy.hcl

  # Create the Agent token
  consul acl token create -description "Agent Token" -policy-name "agent-token" -format json | jq -r '.SecretID' > /config/agent.token

  # Set the agent token on the servers
  #{{ range $i, $instance := .Vars.server_instances }}
  curl -k -s \
    #{{ $.Vars.server_protocol }}://#{{ $instance }}-consul-server.container.shipyard.run:#{{ $.Vars.server_port }}/v1/agent/token/agent \
    -XPUT \
    -d "{\"Token\": \"$(cat /config/agent.token)\"}" #{{ if eq $.Vars.acls_enabled true }}--header "X-Consul-Token: $${CONSUL_HTTP_TOKEN}"#{{ end }}
  #{{ end }}  

  # Create the replication token policy
  cat <<-EOT > /config/replication-policy.hcl
  acl = "write"
  operator = "write"
  agent_prefix "" {
    policy = "read"
  
  }
  node_prefix "" {
    policy = "write"
  }
  
  service_prefix "" {
    policy = "read"
    intentions = "read"
  }
  EOT
  
  consul acl policy create -name "replication-token" -description "Replication Token Policy" -rules @/config/replication-policy.hcl
  
  # Create the Replication token
  consul acl token create -description "Replication Token" -policy-name "replication-token" -format json | jq -r '.SecretID' > /config/replication.token

  #{{ end }}
  EOF

  destination = "${var.cd_consul_data}/bootstrap.sh"

  vars = {
    acls_enabled     = var.cd_consul_acls_enabled
    server_instances = [1, 2, 3]
    server_protocol  = var.cd_consul_tls_protocol
    server_port      = var.cd_consul_api_port
  }
}

exec_remote "cd_consul_bootstrap" {
  target = "container.1-consul-server"

  cmd = "sh"
  args = [
    "/config/bootstrap.sh"
  ]
}

container "1-consul-server" {
  depends_on = ["copy.cd_consul_certs"]
  image {
    name = "consul:${var.cd_consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/server_config.hcl"]

  volume {
    source      = var.cd_consul_data
    destination = "/config"
  }

  network {
    name = "network.${var.cd_consul_network}"
  }

  port {
    local  = 8300
    remote = 8300
    host   = var.cd_consul_ports.rpc
  }

  port {
    local  = 8300
    remote = 8300
    host   = var.cd_consul_ports.rpc
  }

  port {
    local  = 8301
    remote = 8301
    host   = var.cd_consul_ports.lan-serf
  }

  port {
    local  = 8302
    remote = 8302
    host   = var.cd_consul_ports.wan-serf
  }

  port {
    local  = 8500
    remote = 8500
    host   = var.cd_consul_ports.http
  }

  port {
    local  = 8501
    remote = 8501
    host   = var.cd_consul_ports.https
  }

  port {
    local  = 8502
    remote = 8502
    host   = var.cd_consul_ports.grpc
  }

  port {
    local  = 8600
    remote = 8600
    host   = var.cd_consul_ports.dns
  }

  volume {
    source      = var.cd_consul_additional_volume.source
    destination = var.cd_consul_additional_volume.destination
    type        = var.cd_consul_additional_volume.type
  }

  env {
    key   = "CONSUL_HTTP_ADDR"
    value = "${var.cd_consul_tls_protocol}://localhost:${var.cd_consul_api_port}"
  }

  env {
    key   = "CONSUL_HTTP_TOKEN_FILE"
    value = "/config/bootstrap.token"
  }

  env {
    key   = "CONSUL_CACERT"
    value = "/config/cd_consul_ca.cert"
  }
}

container "2-consul-server" {
  disabled   = var.cd_consul_server_instances < 2
  depends_on = ["copy.cd_consul_certs"]

  image {
    name = "consul:${var.cd_consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/server_config.hcl"]

  volume {
    source      = var.cd_consul_data
    destination = "/config"
  }

  network {
    name = "network.${var.cd_consul_network}"
  }

  volume {
    source      = var.cd_consul_additional_volume.source
    destination = var.cd_consul_additional_volume.destination
    type        = var.cd_consul_additional_volume.type
  }
}

container "3-consul-server" {
  disabled   = var.cd_consul_server_instances < 2
  depends_on = ["copy.cd_consul_certs"]

  image {
    name = "consul:${var.cd_consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/server_config.hcl"]

  volume {
    source      = var.cd_consul_data
    destination = "/config"
  }

  network {
    name = "network.${var.cd_consul_network}"
  }

  volume {
    source      = var.cd_consul_additional_volume.source
    destination = var.cd_consul_additional_volume.destination
    type        = var.cd_consul_additional_volume.type
  }
}
