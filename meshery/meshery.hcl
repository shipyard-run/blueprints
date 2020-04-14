exec_remote "fetch_meshery" {
    image {
      name = "shipyardrun/tools:latest"
    }

    cmd = "/scripts/download_meshery.sh"

    network {
      name = "network.local"
    }

    volume {
      source = "./scripts"
      destination = "/scripts"
    }
    
    volume {
      source = "./files"
      destination = "/files"
    }
}

helm "meshery" {
  cluster = "k8s_cluster.k3s"
  depends_on = ["exec_remote.fetch_meshery"]

  chart = "./files/meshery/install/kubernetes/helm/meshery"
  values = "./files/meshery/install/kubernetes/helm/meshery/values.yaml"
}

ingress "meshery" {
  target = "k8s_cluster.k3s"
  service = "svc/meshery"

  port {
    local = 8080
    remote = 8080
    host = 8080
  }
  
  network {
    name = "network.local"
  }
}