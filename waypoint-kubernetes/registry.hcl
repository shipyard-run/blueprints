container "registry" {
  network {
    name       = "network.cloud"
    ip_address = "10.10.0.10"
  }

  image {
    name = "registry:2"
  }

  volume {
    source      = "./files/keys"
    destination = "/certs"
  }

  env_var = {
    REGISTRY_HTTP_ADDR            = "0.0.0.0:443"
    REGISTRY_HTTP_TLS_CERTIFICATE = "/certs/registry.cert"
    REGISTRY_HTTP_TLS_KEY         = "/certs/registry.key"
  }

  port {
    local  = 443
    remote = 443
    host   = 443
  }
}