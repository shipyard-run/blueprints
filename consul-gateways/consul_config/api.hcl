service {
  name = "api"
  id = "api-v1"
  port = 9090

  connect { 
    sidecar_service { }
  }
}