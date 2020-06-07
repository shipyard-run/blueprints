service {
  name = "web"
  id = "web-1"
  port = 9090

  connect { 
    sidecar_service { 
    }
  }
}