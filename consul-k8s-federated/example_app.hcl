template "create_dc2_root_service" {
  depends_on = ["module.consul"]

  source = file("./files/root_dc2_service.hcl")
  destination = "${data("root_dc2_config")}/root_dc2_service.hcl"
}

template "create_dc2_backend_service" {
  depends_on = ["module.consul"]

  source = file("./files/backend_dc2_service.hcl")
  destination = "${data("backend_dc2_config")}/backend_dc2_service.hcl"
}

template "create_dc2_backend_config" {
  depends_on = ["module.consul"]

  source = file("./files/agent_dc2_config.hcl")
  destination = "${data("backend_dc2_config")}/agent_dc2_config.hcl"
}

template "create_dc2_root_config" {
  depends_on = ["module.consul"]

  source = file("./files/agent_dc2_config.hcl")
  destination = "${data("root_dc2_config")}/root_dc2_config.hcl"
}

container "root_dc2_app" {
  disabled = var.install_example_app ? false : true
  depends_on = ["template.create_dc2_root_service"]
    
  image {
    name = "nicholasjackson/fake-service:vm-v0.22.5" 
  }

  network { 
    name = "network.local"
  }

  env_var = {
    CONSUL_SERVER = "10.5.0.201"
    CONSUL_DATACENTER = "dc2"
    UPSTREAM_URIS = "http://localhost:9091"
    SERVICE_ID = "rootvm-1"
  }

  port {
    local = 9090
    remote = 9090
    host = 19092
  }

  volume {
    source = data("root_dc2_config")
    destination = "/config"
  }

  # Add the Consul CA
  volume {
    source = data("dc2")
    destination = "/files"
  }
}

container "backend_dc2_app" {
  disabled = var.install_example_app ? false : true
  depends_on = ["template.create_dc2_backend_service"]
    
  image {
    name = "nicholasjackson/fake-service:vm-v0.22.5" 
  }

  network { 
    name = "network.local"
  }

  env_var = {
    CONSUL_SERVER = "10.5.0.201"
    CONSUL_DATACENTER = "dc2"
    SERVICE_ID = "backendvm-1"
  }

  volume {
    source = data("backend_dc2_config")
    destination = "/config"
  }

  # Add the Consul CA
  volume {
    source = data("dc2")
    destination = "/files"
  }
}

k8s_config "name" {
  disabled = var.install_example_app ? false : true

  depends_on = ["module.consul"]
  cluster = "k8s_cluster.dc1"
  
  paths = [
    "./files/backend_k8s.yaml",
    "./files/root_k8s.yaml",
  ]

  wait_until_ready = true
}

ingress "rootk8s-http" {
  disabled = var.install_example_app ? false : true

  source {
    driver = "local"
    
    config {
      port = 19091
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.dc1"
      address = "rootk8s.default.svc"
      port = 9090
    }
  }
}