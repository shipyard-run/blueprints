# Consul server for DC1 / primary DC
container "consul_dc2" {
  image   {
    name = "consul:1.7.0"
  }

  command = ["consul", "agent", "-config-file=/config/dc2.hcl"]

  volume {
    source      = "./consul_config/dc2.hcl"
    destination = "/config/dc2.hcl"
  }

  # Local network
  network {
    name = "network.dc2"
    # If manually setting IP addresses work from the back of 
    # the block to avoid conflicts.
    # Docker always assigns from the begining of the block
    ip_address = "10.16.0.201"
  }

  # WAN network
  # the server needs to be on the wan to communicate with Consul servers
  # in other DCs
  network {
    name = "network.wan"
    ip_address = "192.168.0.201"
  }
}

container "consul_gateway_dc2" {
  image   {
    name = "nicholasjackson/consul-envoy:v1.7.0-v0.12.2"
  }

  # The following command start a Consul Connect gateway
  command = [
      "consul",
      "connect", "envoy",
      "-mesh-gateway",
      "-register",
      "-address", "10.16.0.203:443",
      "-wan-address", "192.168.0.203:443",
      "--",
      "-l", "debug"]

  volume {
    source      = "./consul_config/dc1.hcl"
    destination = "/config/dc1.hcl"
  }

  network {
    name = "network.dc2"
    ip_address = "10.16.0.203"
  }
  
  network {
    name = "network.wan"
    ip_address = "192.168.0.203"
  }

  # This container does not have a local agent so we are registering the gateway 
  # direct with the server 
  env {
    key = "CONSUL_HTTP_ADDR"
    value = "consul-dc2.container.shipyard.run:8500"
  }
  
  env {
    key = "CONSUL_GRPC_ADDR"
    value = "consul-dc2.container.shipyard.run:8502"
  }
}

# Ingress to allow local access to the Consul UI for the DC1 server
ingress "consul_http_dc2" {
  target = "container.consul_dc2"
    
  network  {
    name = "network.dc2"
  }

  port {
    local  = 8500
    remote = 8500
    host   = 18600
  }
}

# Web application in DC1
container "api_dc2" {
  image   {
    name = "nicholasjackson/fake-service:vm-v0.7.11"
  }

  # Mount the service config for consul agent 
  volume {
    source      = "./consul_config/api.hcl"
    destination = "/config/api.hcl"
  }

  network {
    name = "network.dc2"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul-dc2.container.shipyard.run"
  }

  env {
    key = "CONSUL_DATACENTER"
    value = "dc2"
  }

  env {
    key = "NAME"
    value = "api"
  }

  # Set the Consul service name as specified in the config
  env {
    key = "SERVICE_ID"
    value = "api-v1"
  }
}