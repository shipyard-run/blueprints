k8s_cluster "k3s" {
  driver  = "k3s" // default

  nodes = 1 // default

  network {
    name = "network.local"
  }
}
