k8s_cluster "k3s" {
  driver  = "k3s" // default
  version = "v1.18.8-k3s1-amd64"

  nodes = 1 // default

  network {
    name = "network.local"
  }
}
