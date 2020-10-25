network "dc1" {
  subnet = "10.5.0.0/16"
}

k8s_cluster "dc1" {
  driver  = "k3s" // default
  version = "v1.0.1"

  nodes = 1 // default

  network {
    name = "network.dc1"
  }

  image {
    name = "consul:1.8.0-rc1"
  }
}

k8s_config "dc1" {
  cluster = "k8s_cluster.dc1"
  paths = [
    "./k8s_config/gossip-secret.yaml",
  ]

  wait_until_ready = true
}

helm "dc1" {
  depends_on = ["k8s_config.dc1"]
  cluster = "k8s_cluster.dc1"

  chart = "github.com/hashicorp/consul-helm?ref=v0.24.1"
  values = "./helm/consul-values.yaml"

  values_string = {
    "meshGateway.wanAddress.static" = "192.168.0.200"
    "global.datacenter" = "dc1"
    "global.federation.createFederationSecret" = "true"
  }

  health_check {
    timeout = "120s"
    pods = ["app=consul"]
  }
}

k8s_ingress "consul-dc1" {
  cluster = "k8s_cluster.dc1"

  network {
    name = "network.dc1"
  }

  service  = "consul-ui"

  port {
    local  = 443
    remote = 443
    host   = 1443
  }
}

k8s_ingress "gateway-dc1" {
  cluster = "k8s_cluster.dc1"

  network {
    name = "network.dc1"
  }
  
  network {
    name = "network.wan"
    ip_address = "192.168.0.200"
  }
  
  network {
    name = "network.wan"
  }

  service  = "consul-mesh-gateway"

  port {
    local  = 443
    remote = 443
  }
}

exec_remote "configure" {
  depends_on = ["helm.dc1","k8s_cluster.dc2"]

  image {
    name = "shipyardrun/tools:latest"
  }
  
  network {
    name = "network.dc1"
  }
  
  network {
    name = "network.dc2"
  }
  
  cmd = "bash"
  args = [
    "-c",
    "/files/get_consul_details.sh",
  ]

  volume {
    source = "${k8s_config("dc1")}"
    destination = "/config_dc1.yaml"
  }
  
  volume {
    source = "${k8s_config("dc2")}"
    destination = "/config_dc2.yaml"
  }
  
  volume {
    source = "./files"
    destination = "/files"
  }
}
