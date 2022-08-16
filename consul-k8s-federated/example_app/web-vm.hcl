container "1-web" {
  depends_on = ["copy.consul_ca", "exec_remote.agent_consul_bootstrap"]

  network {
    name = "network.${var.cd_consul_network}"
  }

  image {
    name = "nicholasjackson/fake-service:vm-v0.24.2"
  }

  env {
    key   = "CONSUL_HTTP_TOKEN_FILE"
    value = "/config/web-agent.token"
  }

  env {
    key   = "NAME"
    value = "WEB Primary"
  }

  env {
    key   = "SERVICE_ID"
    value = "web-1"
  }

  env {
    key   = "UPSTREAM_URIS"
    value = "http://localhost:9091"
  }

  volume {
    source      = data("certs")
    destination = "/certs"
  }

  volume {
    source      = "${data("agent_config")}/web-token-config.hcl"
    destination = "/config/token-config.hcl"
  }

  volume {
    source      = "${data("agent_config")}/web-agent.token"
    destination = "/config/web-agent.token"
  }

  volume {
    source      = "./vm_files/agent-config.hcl"
    destination = "/config/config.hcl"
  }

  volume {
    source      = "./vm_files/web-service-1.hcl"
    destination = "/config/web-service-1.hcl"
  }

  volume {
    source      = "./vm_files"
    destination = "/files"
  }

  volume {
    source      = "./vm_files/supervisor.conf"
    destination = "/etc/supervisor/conf.d/fake-service.conf"
  }

  port {
    local  = 9090
    host   = 29090
    remote = 9090
  }
}
