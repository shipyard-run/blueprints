container "tools" {
  image   {
    name = "shipyardrun/tools:v0.6.0"
  }
  
  network {
    name = "network.dc1"
  }

  command = ["tail", "-f", "/dev/null"]

  # Working files
  volume {
    source      = "./files"
    destination = "/files"
  }
  
  volume {
    source      = "./application"
    destination = "/app"
  }

  # Docker sock to be able to to do Docker builds 
  volume {
    source      = "/var/run/docker.sock"
    destination = "/var/run/docker.sock"
  }

  # Shipyard config for Kube 
  volume {
    source      = "${shipyard()}"
    destination = "/root/.shipyard"
  }

  env {
    key = "VAULT_TOKEN"
    value = "root"
  }
  
  env {
    key = "KUBECONFIG"
    value = "/root/.shipyard/config/dc1/kubeconfig-docker.yaml"
  }
  
  env {
    key = "VAULT_ADDR"
    value = "http://${shipyard_ip()}:8200"
  }
}
