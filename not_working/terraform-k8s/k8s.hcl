k8s_cluster "k3s" {
  driver  = "k3s" // default

  nodes = 1 // default

  network {
    name = "network.local"
  }
}

network "local" {
  subnet = "10.7.0.0/16"
}