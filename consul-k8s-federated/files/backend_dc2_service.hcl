service {
  name = "backendvm"
  id = "backendvm-1"
  port = 9090
  tags = ["vm"]

  connect { 
    sidecar_service {
      proxy { }
    }
  }
}