template "consul_agent_config" {
  source      = var.cn_consul_agent_config
  destination = "${data("consul_config")}/agent.hcl"

  vars = {
    datacenter    = var.cn_consul_datacenter
    consul_server = "consul.container.shipyard.run"
  }
}

nomad_cluster "local" {
  depends_on = ["container.consul", "template.consul_agent_config"]

  version      = "${var.cn_nomad_version}"
  client_nodes = var.cn_nomad_client_nodes

  network {
    name = "network.${var.cn_network}"
  }

  consul_config = var.cn_nomad_consul_agent_config
  client_config = var.cn_nomad_client_config
  server_config = var.cn_nomad_server_config

  open_in_browser = var.cn_nomad_open_browser
}
