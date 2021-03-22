template "consul_config" {
  source = var.cn_consul_server_config
  destination = "${file_dir()}/consul_config/server.hcl"
}

container "consul" {
  depends_on = ["template.consul_config"]

  image   {
    name = "${var.cn_consul_image}:${var.cn_consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/server.hcl"]

  volume {
    source      = "./consul_config/server.hcl"
    destination = "/config/server.hcl"
  }

  network {
    name = "network.${var.cn_network}"
  }

  port {
    local = 8500
    remote = 8500
    host = var.cn_consul_port
  }

}