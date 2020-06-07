container "ingress" {
  image {
    name = "nicholasjackson/consul-envoy:v1.8.0-beta2-v0.14.1"
  }
  
  command = [
    "consul", 
    "connect", 
    "envoy", 
    "-gateway=ingress", 
    "-register", 
    "-service=ingress-service", 
    "-address=10.5.0.200:8888"
  ]
  
  network { 
    name = "network.onprem"
    ip_address = "10.5.0.200"
  }
  
  port {
    local  = 8888
    remote = 8888
  }

  port {
    local  = 8080
    remote = 8080
    host   = 8080
  }
  
  env {
    key = "CONSUL_HTTP_ADDR"
    value = "consul.container.shipyard.run:8500"
  }
  
  env {
    key = "CONSUL_GRPC_ADDR"
    value = "consul.container.shipyard.run:8502"
  }
}

container "api" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.11.1"
  }

  volume {
    source      = "./files/api.hcl"
    destination = "/config/api.hcl"
  }

  network { 
    name = "network.onprem"
  }

  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
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
    value = "Hello from API"
  }
}

container "web" {
  image {
    name = "nicholasjackson/fake-service:vm-v0.11.1"
  }

  volume {
    source      = "./files/web.hcl"
    destination = "/config/web.hcl"
  }

  network { 
    name = "network.onprem"
  }
  
  env {
    key = "CONSUL_SERVER"
    value = "consul.container.shipyard.run"
  }
  
  env {
    key = "SERVICE_ID"
    value = "web-1"
  }
  
  env {
    key = "LISTEN_ADDR"
    value = "127.0.0.1:9090"
  }

  env {
    key = "NAME"
    value = "Web Frontend"
  }
  
  env {
    key = "MESSAGE"
    value = "Hello from Web Frontend"
  }
}