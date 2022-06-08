variable "waypoint_odr_tag" {
  default = "0.0.4"
}

# Build a custom ODR with our certs
container "waypoint-odr" {
  network {
    name = "network.cloud"
  }

  build {
    file    = "./Dockerfile.odr"
    context = "./files/keys"
    tag     = var.waypoint_odr_tag
  }

  command = ["/kaniko/waypoint"]
}

exec_remote "waypoint_secrets" {
  depends_on = ["k8s_cluster.kubernetes"]

  image {
    name = "shipyardrun/tools:v0.6.0"
  }

  network {
    name = "network.cloud"
  }

  cmd = "kubectl"
  args = [
    "create",
    "secret",
    "generic",
    "waypoint-certs",
    "--from-file=/certs/waypoint.cert",
    "--from-file=/certs/waypoint.key"
  ]

  volume {
    source      = "${shipyard()}/config/kubernetes"
    destination = "/config"
  }

  env {
    key   = "KUBECONFIG"
    value = "/config/kubeconfig-docker.yaml"
  }

  volume {
    source      = "./files/keys"
    destination = "/certs"
  }
}

helm "waypoint" {
  depends_on = ["exec_remote.waypoint_secrets"]

  cluster = "k8s_cluster.kubernetes"
  chart   = "github.com/hashicorp/waypoint-helm"

  values_string = {
    "server.certs.secretName"     = "waypoint-certs"
    "server.certs.certName"       = "waypoint.cert"
    "server.certs.keyName"        = "waypoint.key"
    "runner.odr.image.repository" = "shipyard.run/localcache/waypoint-odr"
    "runner.odr.image.tag"        = var.waypoint_odr_tag
  }
}

ingress "waypoint_grpc" {
  source {
    driver = "local"
    
    config {
      port = 9701
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.kubernetes"
      address = "waypoint-ui.default.svc"
      port = 9701
    }
  }
}

ingress "waypoint_http" {
  source {
    driver = "local"
    
    config {
      port = 9702
    }
  }
  
  destination {
    driver = "k8s"
    
    config {
      cluster = "k8s_cluster.kubernetes"
      address = "waypoint-ui.default.svc"
      port = 9702
    }
  }
}
