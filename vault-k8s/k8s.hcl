k8s_cluster "k3s" {
  driver  = "k3s" // default

  nodes = 1 // default

  network {
    name = "network.cloud"
  }
}

k8s_config "postgres" {
  cluster = "k8s_cluster.k3s"

  paths = [
    "./files/config/postgres.yml",
  ]

  wait_until_ready = false
}
