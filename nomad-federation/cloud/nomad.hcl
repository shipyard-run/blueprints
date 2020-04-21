nomad_cluster "cloud" {
  version = "v0.11.0"

  nodes = 1 // default

  network {
    name = "network.cloud"
    ip_address = "10.10.0.100"
  }

  network {
    name = "network.wan"
    ip_address = "192.168.10.100"
  }

  volume {
      source = "./nomad_config/server.hcl"
      destination = "/etc/nomad.d/server.hcl"
  }

  volume {
      source = "./consul_config"
      destination = "/config"
  }
}

exec_remote "federation" {
    depends_on = ["nomad_cluster.cloud"]
    cmd = "nomad"
    args = ["server", "join", "192.168.5.100:4648"]

    image {
        name = "shipyardrun/tools:v0.0.16"
    }

    env {
        key = "NOMAD_ADDR"
        value = "http://10.10.0.100:4646"
    }
    
    network {
        name = "network.cloud"
    }
}