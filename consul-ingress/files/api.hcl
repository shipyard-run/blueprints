service {
  name = "api"
  id = "api-1"
  port = 9090

  connect { 
    sidecar_service {
      proxy {
      }
    }
  }
}