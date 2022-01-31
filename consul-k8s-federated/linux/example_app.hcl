template "create_linux_root_service" {
  disabled = var.install_example_app ? false : true

  source = file("./files/root_linux_service.hcl")
  destination = "${data("root_linux_config")}/root_linux_service.hcl"
}

template "create_linux_backend_service" {
  disabled = var.install_example_app ? false : true

  source = file("./files/backend_linux_service.hcl")
  destination = "${data("backend_linux_config")}/backend_linux_service.hcl"
}

template "create_linux_backend_config" {
  disabled = var.install_example_app ? false : true

  source = file("./files/agent_linux_config.hcl")
  destination = "${data("backend_linux_config")}/agent_linux_config.hcl"
}

template "create_linux_root_config" {
  disabled = var.install_example_app ? false : true

  source = file("./files/agent_linux_config.hcl")
  destination = "${data("root_linux_config")}/root_linux_config.hcl"
}

container "root_linux_app" {
  disabled = var.install_example_app ? false : true

  depends_on = ["template.create_linux_root_service"]
    
  image {
    name = "nicholasjackson/fake-service:vm-v0.22.7" 
  }

  network { 
    name = "network.local"
  }

  env_var = {
    CONSUL_SERVER = "10.5.0.201"
    CONSUL_DATACENTER = "linux"
    UPSTREAM_URIS = "http://localhost:9091"
    SERVICE_ID = "rootvm-1"
  }

  port {
    local = 9090
    remote = 9090
    host = 19092
  }

  volume {
    source = data("root_linux_config")
    destination = "/config"
  }

  # Add the Consul CA
  volume {
    source = data("linux")
    destination = "/files"
  }
}

container "backend_linux_app" {
  disabled = var.install_example_app ? false : true
  depends_on = ["template.create_linux_backend_service"]
    
  image {
    name = "nicholasjackson/fake-service:vm-v0.22.7" 
  }

  network { 
    name = "network.local"
  }

  env_var = {
    CONSUL_SERVER = "10.5.0.201"
    CONSUL_DATACENTER = "linux"
    SERVICE_ID = "backendvm-1"
    NAME = "backendvm"
  }

  volume {
    source = data("backend_linux_config")
    destination = "/config"
  }

  # Add the Consul CA
  volume {
    source = data("linux")
    destination = "/files"
  }
}

k8s_config "name" {
  disabled = var.install_example_app ? false : true

  cluster = "k8s_cluster.${var.consul_k8s_cluster}"
  
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
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "rootk8s.default.svc"
      port = 9090
    }
  }
}
