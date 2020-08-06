container "api_1" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.13.2"
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
    value = "API"
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

container "backend_1" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.13.2"
  }

  volume {
    source      = "./files/backend_1.hcl"
    destination = "/config/backend_1.hcl"
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
    value = "0.0.0.0:9090"
  }

  env {
    key = "NAME"
    value = "Backend_Service 1"
  }
  
  env {
    key = "MESSAGE"
    value = "Hello from Backend_Service 1"
  }
}

container "backend_2" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.13.2"
  }

  volume {
    source      = "./files/backend_2.hcl"
    destination = "/config/backend_2.hcl"
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
    value = "backend-2"
  }
  
  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  env {
    key = "NAME"
    value = "Backend_Service 2"
  }
  
  env {
    key = "MESSAGE"
    value = "Hello from Backend Service"
  }
}