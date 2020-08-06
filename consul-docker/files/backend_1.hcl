service {
  name = "backend"
  id = "backend-1"
  port = 9090
  tags = ["v1"]

  connect { 
    sidecar_service { 
    }
  }
}