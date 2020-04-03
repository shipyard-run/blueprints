docs "docs" {
  path  = "./docs"
  port  = 18081
  
  network {
    name = "network.cloud"
  }
}

container "tools" {
  image   {
    name = "shipyardrun/tools:solo"
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

  # Shipyard config for Kube 
  volume {
    source      = "${env("HOME")}/.shipyard"
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