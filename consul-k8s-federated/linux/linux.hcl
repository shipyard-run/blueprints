template "create_linux_certs" {
  source = <<EOF
  #!/bin/sh -e
  cd /files
  consul tls cert create \
    -server \
    -dc linux \
    -node "server" \
    -ca /data/tls.crt \
    -key /data/tls.key
  cp /data/tls.crt /files/tls.crt

  chmod +r /files/tls.crt
  chmod +r /files/linux-server-consul-0-key.pem
  chmod +r /files/linux-server-consul-0.pem
  EOF

  destination = "${data("linux")}/generate_linux_certs.sh"
}

template "create_linux_config" {
  source      = file("./files/server_linux_config.hcl")
  destination = "${data("linux")}/consul_config.hcl"
}

# fetch acl tokens etc
exec_remote "create_linux_certs" {
  depends_on = ["template.create_linux_certs"]

  image {
    name = var.consul_image
  }

  network {
    name = "network.local"
  }

  cmd = "sh"
  args = [
    "/files/generate_linux_certs.sh",
  ]

  volume {
    source      = data("consul_kubernetes") // from Consul module
    destination = "/data"
  }

  volume {
    source      = data("linux")
    destination = "/files"
  }
}

container "linux_server" {
  depends_on = ["exec_remote.create_linux_certs", "template.create_linux_config"]

  image {
    name = var.consul_image
  }

  command = ["consul", "agent", "-config-file=/files/consul_config.hcl", "-log-level=debug"]

  volume {
    source      = data("linux")
    destination = "/files"
  }

  network {
    name       = "network.local"
    ip_address = "10.5.0.201"
    aliases    = ["server.linux.container.shipyard.run"]
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

container "linux_gateway" {
  depends_on = ["container.linux_server"]

  image {
    name = var.consul_and_envoy_image
  }

  entrypoint = [""]
  command = [
    "consul", "connect", "envoy",
    "-gateway", "mesh",
    "-register",
    "-wan-address", "10.5.0.202:443",
    "-address", "10.5.0.202:443",
    "-expose-servers"
  ]

  network {
    name       = "network.local"
    ip_address = "10.5.0.202"
  }

  volume {
    source      = data("linux")
    destination = "/files"
  }

  env_var = {
    CONSUL_HTTP_ADDR = "linux-server.container.shipyard.run:8500"
    CONSUL_GRPC_ADDR = "http://linux-server.container.shipyard.run:8502"
    CONSUL_CACERT    = "/files/tls.crt"
  }
}