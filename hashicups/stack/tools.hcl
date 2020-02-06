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
  
  # Vault files
  volume {
    source      = "./vault_scripts"
    destination = "/files/vault"
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
    key = "VAULT_ADDR"
    value = "http://vault-http.cloud.shipyard:8200"
  }
  
  env {
    key = "KUBECONFIG"
    value = "/root/.shipyard/config/k3s/kubeconfig-docker.yaml"
  }
  
  env {
    key = "CONSUL_HTTP_ADDR"
    value = "http://consul-k8s-http.cloud.shipyard:8500"
  }
  
  env {
    key = "NOMAD_ADDR"
    value = "http://nomad-http.cloud.shipyard:4646"
  }
}