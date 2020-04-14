container "api_1" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.8.0"
  }

  volume {
    source      = "./files/api_1.hcl"
    destination = "/config/api_1.hcl"
  }

  network { 
    name = "network.onprem"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul-1.container.shipyard.run"
  }

  env {
    key = "SERVICE_ID"
    value = "api-1"
  }

  env {
    key = "LISTEN_ADDR"
    value = "0.0.0.0:9090"
  }

  env {
    key = "NAME"
    value = "API_1"
  }
  
  env {
    key = "MESSAGE"
    value = "Hello from API_1"
  }
  
  env {
    key = "UPSTREAM_URIS"
    value = "http://localhost:9091"
  }
}

container "backend" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.8.0"
  }

  volume {
    source      = "./files/backend.hcl"
    destination = "/config/backend.hcl"
  }

  network { 
    name = "network.onprem"
  }
  
  env {
    key = "CONSUL_SERVER"
    value = "consul-1.container.shipyard.run"
  }
  
  env {
    key = "SERVICE_ID"
    value = "backend-1"
  }
  
  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  env {
    key = "NAME"
    value = "Backend_Service"
  }
  
  env {
    key = "MESSAGE"
    value = "Hello from Backend Service"
  }
}