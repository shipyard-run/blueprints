service {
  name = "backend"
  id = "backend-1"
  port = 9090

  connect { 
    sidecar_service { 
    }
  }
}