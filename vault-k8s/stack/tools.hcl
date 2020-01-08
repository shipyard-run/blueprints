container "tools" {
  image   {
    name = "shipyardrun/tools:latest"
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

  network = "network.cloud"

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
    value = "http://vault-http.cloud.shipyard:8200"
  }
}