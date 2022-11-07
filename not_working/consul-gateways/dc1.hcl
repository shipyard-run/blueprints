# Consul server for DC1 / primary DC
container "consul_dc1" {
  image   {
    name = "consul:1.7.0"
  }

  command = ["consul", "agent", "-config-file=/config/dc1.hcl"]

  volume {
    source      = "./consul_config/dc1.hcl"
    destination = "/config/dc1.hcl"
  }

  # Local network
  network {
    name = "network.dc1"
    # If manually setting IP addresses work from the back of 
    # the block to avoid conflicts.
    # Docker always assigns from the begining of the block
    ip_address = "10.15.0.200"
  }

  # WAN network
  # the server needs to be on the wan to communicate with Consul servers
  # in other DCs
  network {
    name = "network.wan"
    ip_address = "192.168.0.200"
  }
}

container "consul_gateway_dc1" {
  image   {
    name = "nicholasjackson/consul-envoy:v1.7.0-v0.12.2"
  }

  # The following command start a Consul Connect gateway
  command = [
      "consul",
      "connect", "envoy",
      "-mesh-gateway",
      "-register",
      "-address", "10.15.0.202:443",
      "-wan-address", "192.168.0.202:443",
      "--",
      "-l", "debug"]

  volume {
    source      = "./consul_config/dc1.hcl"
    destination = "/config/dc1.hcl"
  }

  network {
    name = "network.dc1"
    ip_address = "10.15.0.202"
  }
  
  network {
    name = "network.wan"
    ip_address = "192.168.0.202"
  }

  # This container does not have a local agent so we are registering the gateway 
  # direct with the server 
  env {
    key = "CONSUL_HTTP_ADDR"
    value = "consul-dc1.container.shipyard.run:8500"
  }
  
  env {
    key = "CONSUL_GRPC_ADDR"
    value = "consul-dc1.container.shipyard.run:8502"
  }
}

# Ingress to allow local access to the Consul UI for the DC1 server
container_ingress "consul_http_dc1" {
  target = "container.consul_dc1"
    
  network  {
    name = "network.dc1"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18500
  }
}

# Web application in DC1
container "web_dc1" {
  image   {
    name = "nicholasjackson/fake-service:v0.24.2"
  }

  # Mount the service config for consul agent 
  volume {
    source      = "./consul_config/web.hcl"
    destination = "/config/web.hcl"
  }

  network {
    name = "network.dc1"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul-dc1.container.shipyard.run"
  }

  env {
    key = "NAME"
    value = "web"
  }

  # Upstream URI as specified in the service config
  env {
    key= "UPSTREAM_URIS"
    value = "http://localhost:9091"
  }

  # Set the Consul service name as specified in the config
  env {
    key = "SERVICE_ID"
    value = "web-v1"
  }
}

# Ingress to allow local access to the Web frontend
container_ingress "web_http_dc1" {
  target = "container.web_dc1"
    
  network  {
    name = "network.dc1"
  }

  port {
    local  = 9090
    remote = 9090
    host   = 19090
  }
}
