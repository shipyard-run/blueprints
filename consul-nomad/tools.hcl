container "tools" {
  image   {
    name = "shipyardrun/tools:latest"
  }

  command = ["tail", "-f", "/dev/null"]

  # Nomad files
  volume {
    source      = "./nomad_config"
    destination = "/files/nomad"
  }

  network {
    name = "network.cloud"
  }
  
  env {
    key = "NOMAD_ADDR"
    value = "http://nomad-http.ingress.shipyard:4646"
  }
}