service {
  name = "api"
  id = "api-1"
  port = 9090
  tags = ["v1"]

  connect { 
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "backend"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9091
        }
      }
    }
  }
}