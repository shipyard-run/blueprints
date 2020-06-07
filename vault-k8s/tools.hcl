container "tools" {
  image   {
    name = "shipyardrun/tools:latest"
  }
  
  network {
    name = "network.cloud"
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
    value = "/root/.shipyard/config/k3s/kubeconfig-docker.yaml"
  }
  
  env {
    key = "VAULT_ADDR"
    value = "http://vault-http.ingress.shipyard.run:8200"
  }
}
