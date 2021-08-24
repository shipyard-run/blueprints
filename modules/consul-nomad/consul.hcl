template "consul_server_config" {
  source      = var.cn_consul_server_config
  destination = "${data("consul_config")}/server.hcl"

  vars = {
    datacenter = var.cn_consul_datacenter
  }
}

container "consul" {
  depends_on = ["template.consul_server_config"]

  image {
    name = "${var.cn_consul_image}:${var.cn_consul_version}"
  }

  command = ["consul", "agent", "-config-file=/config/server.hcl"]

  volume {
    source      = "${data("consul_config")}/server.hcl"
    destination = "/config/server.hcl"
  }

  network {
    name = "network.${var.cn_network}"
  }

  port {
    local  = 8500
    remote = 8500
    host   = var.cn_consul_port
  }

}