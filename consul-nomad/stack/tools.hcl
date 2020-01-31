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

  network = "network.cloud"
  
  env {
    key = "NOMAD_ADDR"
    value = "http://nomad-http.cloud.shipyard:4646"
  }
}