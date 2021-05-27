template "create_dc2_certs" {
  depends_on = ["module.consul"]

  source = <<EOF
  #!/bin/sh -e
  cd /files
  consul tls cert create \
    -server \
    -dc dc2 \
    -node "server" \
    -ca /data/tls.crt \
    -key /data/tls.key
  cp /data/tls.crt /files/tls.crt
  EOF

  destination = "${data("dc2")}/generate_dc2_certs.sh"
}

template "create_dc2_config" {
  depends_on = ["module.consul"]

  source = file("./files/server_dc2_config.hcl")
  destination = "${data("dc2")}/consul_config.hcl"
}

# fetch acl tokens etc
exec_remote "create_consul_certs" {
  depends_on = ["template.create_dc2_certs"]

  image {
    name = "shipyardrun/tools:latest"
  }
  
  network {
    name = "network.local"
  }

  cmd = "sh"
  args = [
    "/files/generate_dc2_certs.sh",
  ]
  
  volume {
    source = data("helm")
    destination = "/data"
  }
  
  volume {
    source = data("dc2")
    destination = "/files"
  }
}

container "consul_server" {
  depends_on = ["exec_remote.create_consul_certs", "template.create_dc2_config"]
  
  image {
    name = "consul:1.9.5"
  }
  
  command = ["consul", "agent", "-config-file=/files/consul_config.hcl", "-log-level=debug"]

  volume {
    source      = data("dc2")
    destination = "/files"
  }

  network { 
    name = "network.local"
    ip_address = "10.5.0.201"
    aliases = ["server.dc2.container.shipyard.run"]
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
  
  health_check {
    timeout = "30s"
    http    = "http://localhost:18500/v1/status/leader"
  }
}

container "dc2_gateway" {
  depends_on = ["container.consul_server"]
  
  image {
    name = "nicholasjackson/consul-envoy:v1.9.5-v1.16.0"
  }

  entrypoint = [""]
  command = [
    "consul", "connect", "envoy", 
    "-gateway", "mesh", 
    "-register", 
    "-wan-address","10.5.0.202:443",
    "-address","10.5.0.202:443",
    "-expose-servers"
    ]

  network { 
    name = "network.local"
    ip_address = "10.5.0.202"
  }
  
  volume {
    source      = data("dc2")
    destination = "/files"
  }

  env_var = {
    CONSUL_HTTP_ADDR = "consul-server.container.shipyard.run:8500"
    CONSUL_GRPC_ADDR = "http://consul-server.container.shipyard.run:8502"
    CONSUL_CACERT = "/files/tls.crt"
  }
}