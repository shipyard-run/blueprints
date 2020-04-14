nomad_cluster "nomad" {
  version = "v0.11.0"

  nodes = 1 // default

  network {
    name = "network.cloud"
    ip_address = "10.5.0.2"
  }

  volume {
      source = "./consul_config"
      destination = "/config"
  }
}