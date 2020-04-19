helm "meshery" {
  cluster = "k8s_cluster.k3s"

  chart = "github.com/layer5io/meshery/install/kubernetes/helm//meshery"
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