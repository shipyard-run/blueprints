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

  image {
      name = "consul:1.7.2"
  }

  image {
      name = "nicholasjackson/fake-service:v0.9.0"
  }

  image {
      name = "nicholasjackson/consul-envoy:v1.7.2-v0.14.1"
  }

  image {
      name = "hashicorp/nomad-autoscaler:0.0.1-techpreview2"
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