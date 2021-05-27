service {
  name = "rootvm"
  id = "rootvm-1"
  port = 9090
  tags = ["vm"]

  connect { 
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "backendk8s"
          local_bind_address = "127.0.0.1"
          local_bind_port = 9091
            mesh_gateway {
               mode = "local"
            }
        }
      }
    }
  }
}