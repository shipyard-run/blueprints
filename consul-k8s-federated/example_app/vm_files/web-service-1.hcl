service {
  name = "web"
  id   = "web-1"
  port = 9090
  tags = ["primary"]

  meta = {
    version = "primary"
  }
  checks = [
    {
      id       = "web"
      name     = "HTTP API on port 9090"
      http     = "http://localhost:9090/health"
      interval = "10s"
    }
  ]

  connect {
    sidecar_service {
      proxy {
        upstreams {
          destination_name   = "payments"
          local_bind_address = "127.0.0.1"
          local_bind_port    = 9091
          mesh_gateway {
            mode = "local"
          }
        }
      }
    }
  }
}
