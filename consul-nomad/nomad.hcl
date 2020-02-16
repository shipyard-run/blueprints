nomad_cluster "nomad" {
  version = "v0.10.2"

  nodes = 1 // default

  network {
    name = "network.cloud"
  }

  image {
    name = "consul:1.6.1"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard"
  }
  
  env {
    key = "CONSUL_DATACENTER"
    value = "dc1"
  }
}