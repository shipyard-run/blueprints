nomad_cluster "dev" {
  version = "v0.11.0"
  depends_on = ["container.consul"]

  nodes = 1 // default

  network {
    name = "network.cloud"
    ip_address = "10.15.0.200"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
  }

  env {
    key = "CONSUL_DATACENTER"
    value = "dc1"
  }

  volume {
    source = "./consul_config/consul-agent.hcl"
    destination = "/config/consul.hcl"
  }
  
  image {
      name = "nicholasjackson/fake-service:vm-v0.14.1"
  }
  
}
