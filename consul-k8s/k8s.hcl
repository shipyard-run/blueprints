k8s_cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.0.1"

  nodes = 1 // default

  network {
    name = "network.cloud"
  }
}

k8s_config "app" {
  cluster = "k8s_cluster.k3s"
  depends_on = ["helm.consul"]

  paths = ["./k8s_config/"]
  wait_until_ready = true
}