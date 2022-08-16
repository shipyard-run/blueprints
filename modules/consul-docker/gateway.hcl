container "gateway" {
  disabled   = !var.cd_gateway_enabled
  depends_on = ["exec_remote.cd_consul_bootstrap"]

  image {
    name = "nicholasjackson/consul-envoy:${var.cd_gateway_version}"
  }

  entrypoint = [""]
  command = [
    "consul", "connect", "envoy",
    "-gateway", "mesh",
    "-register",
    "-wan-address", "${var.cd_gateway_ip}:443",
    "-address", "${var.cd_gateway_ip}:443",
    "-expose-servers"
  ]

  network {
    name       = "network.${var.cd_consul_network}"
    ip_address = var.cd_gateway_ip
  }

  volume {
    source      = var.cd_consul_certs_data
    destination = "/files"
  }

  volume {
    source      = var.cd_consul_data
    destination = "/tokens"
  }

  env_var = {
    CONSUL_HTTP_ADDR       = "${var.cd_consul_tls_protocol}://1-consul-server.container.shipyard.run:${var.cd_consul_api_port}"
    CONSUL_GRPC_ADDR       = "${var.cd_consul_tls_protocol}://1-consul-server.container.shipyard.run:8502"
    CONSUL_CACERT          = var.cd_consul_tls_enabled ? "/files/cd_consul_ca.cert" : ""
    CONSUL_HTTP_TOKEN_FILE = var.cd_consul_acls_enabled ? "/tokens/bootstrap.token" : ""
  }
}
