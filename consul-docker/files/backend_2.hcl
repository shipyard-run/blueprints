service {
  name = "backend"
  id = "backend-2"
  port = 9090
  tags = ["v2"]

  connect { 
    sidecar_service { 
    }
  }
}