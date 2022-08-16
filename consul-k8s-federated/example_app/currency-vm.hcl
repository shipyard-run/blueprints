container "1-currency" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "CONSUL_HTTP_TOKEN_FILE"
    value = "/config/currency-agent.token"
  }

  env {
    key   = "NAME"
    value = "Currency - 1 (primary)"
  }

  env {
    key   = "SERVICE_ID"
    value = "currency-1"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/currency-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "${data("agent_config")}/currency-agent.token"
    destination = "/config/currency-agent.token"
  }

  volume {
    source      = "./vm_files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "./vm_files/currency-service-1.hcl"
    destination = "/config/currency-service-1.hcl"
  }

  volume {
    source      = "./vm_files"
    destination = "/files"
  }

  volume {
    source      = "./vm_files/supervisor.conf"
    destination = "/etc/supervisor/conf.d/fake-service.conf"
  }
}
