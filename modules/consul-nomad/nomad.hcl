nomad_cluster "local" {
  depends_on = ["container.consul"]
  
  version = "v${var.cn_nomad_version}"
  client_nodes = var.cn_nomad_client_nodes

  network {
    name = "network.${var.cn_network}"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
  }
  
  env {
    key = "CONSUL_DATACENTER"
    value = "dc1"
  }
}