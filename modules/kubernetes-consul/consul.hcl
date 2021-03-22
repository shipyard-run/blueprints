//
// Install Consul using the helm chart.
//
helm "consul" {
  cluster = "k8s_cluster.${var.consul_k8s_cluster}"

  // chart = "github.com/hashicorp/consul-helm?ref=crd-controller-base"
  chart = "github.com/hashicorp/consul-helm?ref=v0.28.0"
  values = var.consul_helm_values

  health_check {
    timeout = "120s"
    pods = ["app=consul"]
  }
}

ingress "consul" {
  source {
    driver = "local"
    
    config {
      port = var.consul_api_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.default.svc"
      port = 8500
    }
  }
}

ingress "consul-rpc" {
  source {
    driver = "local"
    
    config {
      port = var.consul_rpc_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.default.svc"
      port = 8300
    }
  }
}

ingress "consul-lan-serf" {
  source {
    driver = "local"
    
    config {
      port = var.consul_lan_port
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.${var.consul_k8s_cluster}"
      address = "consul-server.default.svc"
      port = 8301
    }
  }
}
